unit ojVirtualTrees.WorkerThread;

interface

uses
  System.Classes,
  ojVirtualTrees;

type
  // internal worker thread
  TWorkerThread = class(TThread)
  private
    FCurrentTree: TojBaseVirtualTree;
    FWaiterList: TThreadList;
    FRefCount: Cardinal;
  protected
    procedure CancelValidation(Tree: TojBaseVirtualTree);
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;

    procedure AddTree(Tree: TojBaseVirtualTree);
    procedure RemoveTree(Tree: TojBaseVirtualTree);

    property CurrentTree: TojBaseVirtualTree read FCurrentTree;
  end;


procedure AddThreadReference;
procedure ReleaseThreadReference(Tree: TojBaseVirtualTree);


var
  WorkerThread: TWorkerThread;
  WorkEvent: THandle;


implementation

uses
  Winapi.Windows,
  System.Types,
  System.SysUtils;

type
  TojBaseVirtualTreeCracker = class(TojBaseVirtualTree)
  end;

//----------------- TWorkerThread --------------------------------------------------------------------------------------

procedure AddThreadReference;
begin
  if not Assigned(WorkerThread) then
  begin
    // Create an event used to trigger our worker thread when something is to do.
    WorkEvent := CreateEvent(nil, False, False, nil);
    if WorkEvent = 0 then
      RaiseLastOSError;

    // Create worker thread, initialize it and send it to its wait loop.
    WorkerThread := TWorkerThread.Create(False);
  end;
  Inc(WorkerThread.FRefCount);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure ReleaseThreadReference(Tree: TojBaseVirtualTree);

begin
  if Assigned(WorkerThread) then
  begin
    Dec(WorkerThread.FRefCount);

    // Make sure there is no reference remaining to the releasing tree.
    TojBaseVirtualTreeCracker(Tree).InterruptValidation;

    if WorkerThread.FRefCount = 0 then
    begin
      with WorkerThread do
      begin
        Terminate;
        SetEvent(WorkEvent);
      end;
      FreeAndNil(WorkerThread);
      CloseHandle(WorkEvent);
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

constructor TWorkerThread.Create(CreateSuspended: Boolean);

begin
  inherited Create(CreateSuspended);
  FWaiterList := TThreadList.Create;
end;

//----------------------------------------------------------------------------------------------------------------------

destructor TWorkerThread.Destroy;

begin
  // First let the ancestor stop the thread before freeing our resources.
  inherited;

  FWaiterList.Free;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWorkerThread.CancelValidation(Tree: TojBaseVirtualTree);

var
  Msg: TMsg;

begin
  // Wait for any references to this tree to be released.
  // Pump WM_CHANGESTATE messages so the thread doesn't block on SendMessage calls.
  while FCurrentTree = Tree do
  begin
    if Tree.HandleAllocated and PeekMessage(Msg, Tree.Handle, WM_CHANGESTATE, WM_CHANGESTATE, PM_REMOVE) then
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
      Continue;
    end;
    if (toVariableNodeHeight in TojBaseVirtualTreeCracker(Tree).TreeOptions.MiscOptions) then
      CheckSynchronize(); // We need to call CheckSynchronize here because we are using TThread.Synchronize in TojBaseVirtualTree.MeasureItemHeight()
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWorkerThread.Execute;

// Does some background tasks, like validating tree caches.

var
  EnterStates,
  LeaveStates: TChangeStates;
  lCurrentTree: TojBaseVirtualTree;

begin
  TThread.NameThreadForDebugging('VirtualTrees.TWorkerThread');
  while not Terminated do
  begin
    WaitForSingleObject(WorkEvent, INFINITE);
    if not Terminated then
    begin
      // Get the next waiting tree.
      with FWaiterList.LockList do
      try
        if Count > 0 then
        begin
          FCurrentTree := Items[0];
          // Remove this tree from waiter list.
          Delete(0);
          // If there is yet another tree to work on then set the work event to keep looping.
          if Count > 0 then
            SetEvent(WorkEvent);
        end
        else
          FCurrentTree := nil;
      finally
        FWaiterList.UnlockList;
      end;

      // Something to do?
      if Assigned(FCurrentTree) then
      begin
        try
          TojBaseVirtualTreeCracker(FCurrentTree).ChangeTreeStatesAsync([csValidating], [csUseCache, csValidationNeeded]);
          EnterStates := [];
          if not (tsStopValidation in FCurrentTree.TreeStates) and TojBaseVirtualTreeCracker(FCurrentTree).DoValidateCache then
            EnterStates := [csUseCache];

        finally
          LeaveStates := [csValidating, csStopValidation];
          TojBaseVirtualTreeCracker(FCurrentTree).ChangeTreeStatesAsync(EnterStates, LeaveStates);
          lCurrentTree := FCurrentTree; // Save reference in a local variable for later use
          FCurrentTree := nil; //Clear variable to prevent deadlock in CancelValidation. See #434
          Queue(TojBaseVirtualTreeCracker(lCurrentTree).UpdateEditBounds);
        end;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWorkerThread.AddTree(Tree: TojBaseVirtualTree);

begin
  Assert(Assigned(Tree), 'Tree must not be nil.');

  // Remove validation stop flag, just in case it is still set.
  TojBaseVirtualTreeCracker(Tree).DoStateChange([], [tsStopValidation]);
  with FWaiterList.LockList do
  try
    if IndexOf(Tree) = -1 then
      Add(Tree);
  finally
    FWaiterList.UnlockList;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWorkerThread.RemoveTree(Tree: TojBaseVirtualTree);

begin
  Assert(Assigned(Tree), 'Tree must not be nil.');

  with FWaiterList.LockList do
  try
    Remove(Tree);
  finally
    FWaiterList.UnlockList; // Seen several AVs in this line, was called from TWorkerThrea.Destroy. Joachim Marder.
  end;
  CancelValidation(Tree);
end;


end.
