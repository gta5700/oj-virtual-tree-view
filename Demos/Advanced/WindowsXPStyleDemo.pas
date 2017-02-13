unit WindowsXPStyleDemo;

// Virtual Treeview sample form demonstrating following features:
//   - Windows XP style treeview.
// Written by Mike Lischke.

interface

{$warn UNSAFE_TYPE off}
{$warn UNSAFE_CAST off}
{$warn UNSAFE_CODE off}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ojVirtualTrees, ImgList, ComCtrls, ToolWin, Menus, StdCtrls, UITypes;

type
  TWindowsXPForm = class(TForm)
    XPTree: TojVirtualStringTree;
    LargeImages: TImageList;
    SmallImages: TImageList;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    Label1: TLabel;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    PrintDialog: TPrintDialog;
    procedure XPTreeGetImageIndex(Sender: TojBaseVirtualTree; Node: TojVirtualNode; Kind: TVTImageKind;
      Column: TColumnIndex; var Ghosted: Boolean; var Index: TImageIndex);
    procedure FormCreate(Sender: TObject);
    procedure XPTreeInitNode(Sender: TojBaseVirtualTree; ParentNode, Node: TojVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure XPTreeInitChildren(Sender: TojBaseVirtualTree; Node: TojVirtualNode; var ChildCount: Cardinal);
    procedure XPTreeGetText(Sender: TojBaseVirtualTree; Node: TojVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: UnicodeString);
    procedure XPTreeHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure XPTreeCompareNodes(Sender: TojBaseVirtualTree; Node1, Node2: TojVirtualNode; Column: TColumnIndex;
      var Result: Integer);
    procedure Label4Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure XPTreeStateChange(Sender: TojBaseVirtualTree; Enter, Leave: TVirtualTreeStates);
    procedure XPTree_OnGetNodeUserDataClass(Sender: TojBaseVirtualTree; var NodeUserDataClass: TClass);
    procedure XPTreeGetHint(Sender: TojBaseVirtualTree; Node: TojVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: string);
  end;

var
  WindowsXPForm: TWindowsXPForm;

//----------------------------------------------------------------------------------------------------------------------

implementation

uses
  Main, ShellAPI, Printers, States;

{$R *.dfm}

type
  //PEntry = ^TEntry;
  TEntryRec = record
    Caption: UnicodeString;
    Image: Integer;
    Size: Int64;
  end;

  TEntry = class
    Caption: UnicodeString;
    Image: Integer;
    Size: Int64;
  end;
var
  TreeEntries: array[0..17] of TEntryRec = (
    (Caption: 'My Computer'; Image: 0; Size: 0),
    (Caption: 'Network Places'; Image: 1; Size: 0),
    (Caption: 'Recycle Bin'; Image: 2; Size: 0),
    (Caption: 'My Documents'; Image: 3; Size: 0),
    (Caption: 'My Music'; Image: 4; Size: 0),
    (Caption: 'My Pictures'; Image: 5; Size: 0),
    (Caption: 'Control Panel'; Image: 6; Size: 0),
    (Caption: 'Help'; Image: 7; Size: 0),
    (Caption: 'Help Document'; Image: 8; Size: 0),
    (Caption: 'User Accounts'; Image: 9; Size: 0),
    (Caption: 'Internet'; Image: 10; Size: 0),
    (Caption: 'Network Group'; Image: 11; Size: 0),
    (Caption: 'Folder'; Image: 12; Size: 0),
    (Caption: 'Window'; Image: 13; Size: 0),
    (Caption: 'Warning'; Image: 14; Size: 0),
    (Caption: 'Information'; Image: 15; Size: 0),
    (Caption: 'Critical'; Image: 16; Size: 0),
    (Caption: 'Security'; Image: 17; Size: 0)
  );

//----------------------------------------------------------------------------------------------------------------------

procedure TWindowsXPForm.XPTreeGetHint(Sender: TojBaseVirtualTree;
  Node: TojVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: string);
begin
  // Show only a dummy hint. It is just to demonstrate how to do it.
  HintText := 'Size larger than 536 MB' + #13 +
    'Folders: addins, AppPatch, Config, Connection Wizard, ...' + #13 +
    'Files: 1280.bmp, 1280x1024.bmp, 2001 94 mars.bmp, ac3api.ini, ...';
end;

procedure TWindowsXPForm.XPTreeGetImageIndex(Sender: TojBaseVirtualTree; Node: TojVirtualNode;
  Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var Index: TImageIndex);
var
  Data: TEntry;
begin
  /// Data := Sender.GetNodeData(Node);
  Data:= Node.UserData as TEntry;
  case Kind of
    ikNormal, ikSelected:
      if (Column = 0) and (Node.Parent = Sender.RootNode) then
        Index := Data.Image;
    ikState:
      case Column of
        0:
          if Node.Parent <> Sender.RootNode then
            Index := 21;
      end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWindowsXPForm.FormCreate(Sender: TObject);
begin
  // We assign these handlers manually to keep the demo source code compatible
  // with older Delphi versions after using UnicodeString instead of WideString.
  XPTree.OnGetText := XPTreeGetText;
  XPTree.OnGetHint := XPTreeGetHint;

  {$MESSAGE 'GTA ------ UNLOCK ------ '}
  //XPTree.NodeDataSize := SizeOf(TEntry);

  ConvertToHighColor(LargeImages);
  ConvertToHighColor(SmallImages);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWindowsXPForm.XPTreeInitNode(Sender: TojBaseVirtualTree; ParentNode, Node: TojVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
var
  Data: TEntry;
begin
  if ParentNode = nil then
  begin
    Include(InitialStates, ivsHasChildren);
    //  Data := Sender.GetNodeData(Node);
    Data:= Node.UserData as TEntry;

    Data.Caption:= TreeEntries[Node.Index mod 18].Caption;
    Data.Image:= TreeEntries[Node.Index mod 18].Image;
    Data.Size := Random(100000);
    Node.CheckType := ctCheckBox;
  end
  else
    Node.CheckType := ctRadioButton;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWindowsXPForm.XPTreeInitChildren(Sender: TojBaseVirtualTree; Node: TojVirtualNode;
  var ChildCount: Cardinal);
begin
  ChildCount := 5;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWindowsXPForm.XPTreeGetText(Sender: TojBaseVirtualTree; Node: TojVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: UnicodeString);
var
  Data: TEntry;
begin
  //Data := Sender.GetNodeData(Node);
  Data:= Node.UserData as TEntry;

  case Column of
    0:
      if Node.Parent = Sender.RootNode then
        CellText := Data.Caption
      else
        CellText := 'More entries';
    1:
      if Node.Parent = Sender.RootNode then
        CellText := FloatToStr(Data.Size / 1000) + ' MB';
    2:
      if Node.Parent = Sender.RootNode then
        CellText := 'System Folder';
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWindowsXPForm.XPTreeHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
begin
  if HitInfo.Button = mbLeft then
  begin
    with Sender, Treeview do
    begin
      if SortColumn > NoColumn then
        Columns[SortColumn].Options := Columns[SortColumn].Options + [coParentColor];

      // Do not sort the last column, it contains nothing to sort.
      if HitInfo.Column = 2 then
        SortColumn := NoColumn
      else
      begin
        if (SortColumn = NoColumn) or (SortColumn <> HitInfo.Column) then
        begin
          SortColumn := HitInfo.Column;
          SortDirection := sdAscending;
        end
        else
          if SortDirection = sdAscending then
            SortDirection := sdDescending
          else
            SortDirection := sdAscending;

        if SortColumn <> NoColumn then
          Columns[SortColumn].Color := $F7F7F7;
        SortTree(SortColumn, SortDirection, True);

      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWindowsXPForm.XPTreeCompareNodes(Sender: TojBaseVirtualTree; Node1, Node2: TojVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var Data1, Data2: TEntry;
begin
  //  Data1 := Sender.GetNodeData(Node1);
  //  Data2 := Sender.GetNodeData(Node2);
  Data1:= Node1.UserData as TEntry;
  Data2:= Node1.UserData as TEntry;

  case Column of
    0: Result := CompareText(Data1.Caption, Data2.Caption);
    1: Result := Data1.Size - Data2.Size;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWindowsXPForm.Label4Click(Sender: TObject);

begin
    ShellExecute(0, 'open', 'https://groups.google.com/forum/#!forum/virtual-treeview', nil, nil, SW_SHOW);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWindowsXPForm.ToolButton9Click(Sender: TObject);
begin
  if PrintDialog.Execute then
    XPTree.Print(Printer, False);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TWindowsXPForm.XPTreeStateChange(Sender: TojBaseVirtualTree; Enter, Leave: TVirtualTreeStates);
begin
  if not (csDestroying in ComponentState) then
    UpdateStateDisplay(Sender.TreeStates, Enter, Leave);
end;

procedure TWindowsXPForm.XPTree_OnGetNodeUserDataClass(Sender: TojBaseVirtualTree; var NodeUserDataClass: TClass);
begin
  NodeUserDataClass:= TEntry;
end;

//----------------------------------------------------------------------------------------------------------------------

//procedure TWindowsXPForm.XPTreeFreeNode(Sender: TojBaseVirtualTree; Node: TojVirtualNode);
//var Data: PEntry;
//begin
//  Data := Sender.GetNodeData(Node);
//  Finalize(Data^);
//end;

end.
