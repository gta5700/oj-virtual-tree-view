unit MainOJ;

// Demonstration project for TojVirtualStringTree to generally show how to get started.
// Written by Mike Lischke.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ojVirtualTrees, StdCtrls, ExtCtrls, strUtils, System.Types;

type
  TMainForm = class(TForm)
    VST: TojVirtualStringTree;
    ClearButton: TButton;
    AddOneButton: TButton;
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    CloseButton: TButton;
    Button2: TButton;
    btnSaveToStream: TButton;
    btnLoadFromStream: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure VSTInitNode(Sender: TojBaseVirtualTree; ParentNode, Node: TojVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure VSTFreeNode(Sender: TojBaseVirtualTree; Node: TojVirtualNode);
    procedure VSTGetText(Sender: TojBaseVirtualTree; Node: TojVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VST_OnGetNodeUserDataClass(Sender: TojBaseVirtualTree; var NodeUserDataClass: TClass);
    procedure btnSaveToStreamClick(Sender: TObject);
    procedure btnLoadFromStreamClick(Sender: TObject);
    procedure VSTGetCellText(Sender: TojCustomVirtualStringTree; var E: TVSTGetCellTextEventArgs);
  end;



var
  MainForm: TMainForm;

//----------------------------------------------------------------------------------------------------------------------

implementation

{$R *.DFM}

type

  TojStringData = class
    Caption: string;
  end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.FormCreate(Sender: TObject);

begin
  // We assign the OnGetText handler manually to keep the demo source code compatible
  // with older Delphi versions after using UnicodeString instead of WideString.
  VST.OnGetText := VSTGetText;

  //  Let the tree know how much data space we need.
  //  VST.NodeDataSize := SizeOf(TMyRec);

  // Set an initial number of nodes.
  VST.RootNodeCount := 120;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.btnLoadFromStreamClick(Sender: TObject);
var v_fpath, v_app_path: string;
    v_stream: TMemoryStream;
begin
  v_app_path:= ChangeFileExt(Application.ExeName, '');

  v_fpath:= v_app_path + '_tree' + '.vtv';
  if FileExists(v_fpath) then
  begin
    v_stream:= TMemoryStream.Create;
    try
      v_stream.LoadFromFile(v_fpath);
      v_stream.Position:= 0;
      VST.LoadFromStream(v_stream);
    finally
      FreeAndNil(v_stream);
    end;
  end
  else
   ShowMessage('No such file as ' +v_fpath);


  v_fpath:= v_app_path + '_header' + '.vtv';
  if FileExists(v_fpath) then
  begin
    v_stream:= TMemoryStream.Create;
    try
      v_stream.LoadFromFile(v_fpath);
      v_stream.Position:= 0;
      VST.Header.LoadFromStream(v_stream);
    finally
      FreeAndNil(v_stream);
    end;
  end
  else
   ShowMessage('No such file as ' +v_fpath);

end;

procedure TMainForm.btnSaveToStreamClick(Sender: TObject);
var v_fpath, v_app_path: string;
    v_stream: TMemoryStream;
begin
  v_app_path:= ChangeFileExt(Application.ExeName, '');

  v_fpath:= v_app_path + '_tree' + '.vtv';
  v_stream:= TMemoryStream.Create;
  try
    VST.SaveToStream(v_stream, nil);
    v_stream.SaveToFile(v_fpath);
  finally
    FreeAndNil(v_stream);
  end;

  v_fpath:= v_app_path + '_header' + '.vtv';
  v_stream:= TMemoryStream.Create;
  try
    VST.Header.SaveToStream(v_stream);
    v_stream.SaveToFile(v_fpath);
  finally
    FreeAndNil(v_stream);
  end;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  //  VST.NodeDataSize:= 100;
  VST._UserDataClassName:= '';
end;

procedure TMainForm.ClearButtonClick(Sender: TObject);

var
  Start: Cardinal;

begin
  Screen.Cursor := crHourGlass;
  try
    Start := GetTickCount;
    VST.Clear;
    Label1.Caption := Format('Last operation duration: %d ms, TNC: %d', [GetTickCount - Start, TojVirtualNode.TotalNodeCount]);
  finally
    Screen.Cursor := crDefault;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.AddButtonClick(Sender: TObject);

var
  Count: Cardinal;
  Start: Cardinal;

begin
  // Add some nodes to the treeview.
  Screen.Cursor := crHourGlass;
  with VST do
  try
    Start := GetTickCount;
    case (Sender as TButton).Tag of
      0: // add to root
        begin
          Count := StrToInt(Edit1.Text);
          RootNodeCount := RootNodeCount + Count;
        end;
      1: // add as child
        if Assigned(FocusedNode) then
        begin
          Count := StrToInt(Edit1.Text);
          ChildCount[FocusedNode] := ChildCount[FocusedNode] + Count;
          Expanded[FocusedNode] := True;
          InvalidateToBottom(FocusedNode);
        end;
    end;
    Label1.Caption := Format('Last operation duration: %d ms, TNC: %d', [GetTickCount - Start, TojVirtualNode.TotalNodeCount]);
  finally
    Screen.Cursor := crDefault;
  end;
end;


//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.VSTFreeNode(Sender: TojBaseVirtualTree; Node: TojVirtualNode);
//var
//  Data: PMyRec;
begin
  //  UserData is owned by tree; do nothing
//  Data := Sender.GetNodeData(Node);
//  // Explicitely free the string, the VCL cannot know that there is one but needs to free
//  // it nonetheless. For more fields in such a record which must be freed use Finalize(Data^) instead touching
//  // every member individually.
//  Finalize(Data^);
end;



procedure TMainForm.VSTGetCellText(Sender: TojCustomVirtualStringTree; var E: TVSTGetCellTextEventArgs);
begin

  with sender do
  case GetNodeLevel(E.Node) of
    0: E.CellText:= E.FieldName + ' ' +TojVirtualStringNode(E.Node).Caption;
    1: E.CellText:= E.Node.Tag ;
  else
    E.CellText:= sender.GetNodeData<TojStringData>(E.Node).Caption;
    //  E.CellText:= TojVirtualStringNode(E.Node).Caption;
  end;

end;

procedure TMainForm.VSTGetText(Sender: TojBaseVirtualTree; Node: TojVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  //  CellText:= TojVirtualStringNode(Node).Caption;
  with sender do
  case GetNodeLevel(Node) of
    0: CellText:= TojVirtualStringNode(Node).Caption;
    1: CellText:= Node.Tag;
  else
    CellText:= TojVirtualStringNode(Node).Caption;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TMainForm.VSTInitNode(Sender: TojBaseVirtualTree; ParentNode,
  Node: TojVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  with sender do
  case GetNodeLevel(Node) of
    0: TojVirtualStringNode(Node).Caption := Format('CPT  Level %d, Index %d', [GetNodeLevel(Node), Node.Index]);
    1: Node.Tag:= Format('TAG  Level %d, Index %d', [GetNodeLevel(Node), Node.Index]);
  else
    TojVirtualStringNode(Node).Caption:= Format('CPTE Level %d, Index %d', [GetNodeLevel(Node), Node.Index]);
  end;

end;


procedure TMainForm.VST_OnGetNodeUserDataClass(Sender: TojBaseVirtualTree;
  var NodeUserDataClass: TClass);
begin
  if NodeUserDataClass = nil
  then NodeUserDataClass:= TojStringData;
end;


procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;



initialization
  //  GTA
  TojVirtualStringTree.registerUserDataClass(TojStringData);


finalization

end.


