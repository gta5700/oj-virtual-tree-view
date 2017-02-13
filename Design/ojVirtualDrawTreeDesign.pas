unit ojVirtualDrawTreeDesign;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ojVirtualTrees, StdCtrls, CheckLst;

type

  TojVirtualDrawTreeDesignForm = class(TForm)
    chAutoOptionsList: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    chMiscOptionsList: TCheckListBox;
    Label3: TLabel;
    chPaintOptionsList: TCheckListBox;
    Label4: TLabel;
    chSelectionOptionsList: TCheckListBox;
    lblInfo: TLabel;
    Label5: TLabel;
    chAnimationOptionsList: TCheckListBox;
    btnRestoreAutoOptions: TButton;
    btnRestoreSelectionOptions: TButton;
    btnRestorePaintOptions: TButton;
    btnRestoreMiscOptions: TButton;
    btnRestoreAnimationOptions: TButton;
    procedure chAutoOptionsListClickCheck(Sender: TObject);
    procedure chMiscOptionsListClickCheck(Sender: TObject);
    procedure chPaintOptionsListClickCheck(Sender: TObject);
    procedure chSelectionOptionsListClickCheck(Sender: TObject);
    procedure chAutoOptionsListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure chAnimationOptionsListClickCheck(Sender: TObject);
    procedure chAnimationOptionsListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure chMiscOptionsListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure chPaintOptionsListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure chSelectionOptionsListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnRestoreAutoOptionsClick(Sender: TObject);
    procedure btnRestoreSelectionOptionsClick(Sender: TObject);
    procedure btnRestorePaintOptionsClick(Sender: TObject);
    procedure btnRestoreMiscOptionsClick(Sender: TObject);
    procedure btnRestoreAnimationOptionsClick(Sender: TObject);
  private
    FVirtualTree: TojCustomVirtualDrawTree;
  protected
    procedure FillAutoOptionsList;
    procedure FillMiscOptionsList;
    procedure FillPaintOptionsList;
    procedure FillSelectionOptionsList;
    procedure FillAnimationOptionsList;
  public
    constructor Create(AOwner: TComponent; VirtualTree: TojCustomVirtualDrawTree);reintroduce;overload;virtual;

    function getVirtualTree: TojCustomVirtualDrawTree;
  public
    class procedure ShowDesigner(p_VirtualTree: TojCustomVirtualDrawTree);
  end;


implementation
uses typInfo;
{$R *.dfm}
type
  TFakeCustomVirtualDrawTree = class(TojCustomVirtualDrawTree);
  TFakeCustomVirtualTreeOptions = class(TCustomVirtualTreeOptions);
{ TVirtualDrawTreeDesignForm }

procedure TojVirtualDrawTreeDesignForm.btnRestoreAnimationOptionsClick(Sender: TObject);
var v_tree: TFakeCustomVirtualDrawTree;
begin
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).AnimationOptions:= DefaultAnimationOptions;
  FillAnimationOptionsList;
end;

procedure TojVirtualDrawTreeDesignForm.btnRestoreAutoOptionsClick(Sender: TObject);
var v_tree: TFakeCustomVirtualDrawTree;
begin
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).AnimationOptions:= DefaultAnimationOptions;
  FillAutoOptionsList;
end;

procedure TojVirtualDrawTreeDesignForm.btnRestoreMiscOptionsClick(Sender: TObject);
var v_tree: TFakeCustomVirtualDrawTree;
begin
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).MiscOptions:= DefaultMiscOptions;
  FillMiscOptionsList;
end;

procedure TojVirtualDrawTreeDesignForm.btnRestorePaintOptionsClick(Sender: TObject);
var v_tree: TFakeCustomVirtualDrawTree;
begin
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).PaintOptions:= DefaultPaintOptions;
  FillPaintOptionsList;
end;

procedure TojVirtualDrawTreeDesignForm.btnRestoreSelectionOptionsClick(Sender: TObject);
var v_tree: TFakeCustomVirtualDrawTree;
begin
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).SelectionOptions:= DefaultSelectionOptions;
  FillSelectionOptionsList;
end;

procedure TojVirtualDrawTreeDesignForm.chAnimationOptionsListClickCheck(Sender: TObject);
var v_opt: TVTAnimationOption;
    v_opts: TVTAnimationOptions;
    v_tree: TFakeCustomVirtualDrawTree;
    i: integer;
begin
  v_opts:= [];
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  for i:= 0 to chAnimationOptionsList.Items.Count-1 do
    if chAnimationOptionsList.Checked[i] then
      begin
        v_opt:= TVTAnimationOption(GetEnumValue(TypeInfo(TVTAnimationOption), chAnimationOptionsList.Items[i]));
        v_opts:= v_opts + [v_opt];
      end;
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).AnimationOptions:= v_opts;
end;

procedure TojVirtualDrawTreeDesignForm.chAnimationOptionsListMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
var v_idx: Integer;
    v_opt: TVTAnimationOption;
begin
  v_idx:= chAnimationOptionsList.ItemAtPos(Point(X, Y), TRUE);
  if v_idx >= 0  then
    begin
      v_opt:= TVTAnimationOption(GetEnumValue(TypeInfo(TVTAnimationOption), chAnimationOptionsList.Items[v_idx]));
      //  lblInfo.Caption:= VTAutoOptionDescriptions[v_opt];
      lblInfo.Caption:= chAnimationOptionsList.Items[v_idx] + ':' + sLineBreak +
                        VTAnimationOptionDescriptions[v_opt];
    end
  else
    lblInfo.Caption:= '';
end;

procedure TojVirtualDrawTreeDesignForm.chAutoOptionsListClickCheck(Sender: TObject);
var v_opt: TVTAutoOption;
    v_opts: TVTAutoOptions;
    v_tree: TFakeCustomVirtualDrawTree;
    i: integer;
begin
  v_opts:= [];
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  for i:= 0 to chAutoOptionsList.Items.Count-1 do
    if chAutoOptionsList.Checked[i] then
      begin
        v_opt:= TVTAutoOption(GetEnumValue(TypeInfo(TVTAutoOption), chAutoOptionsList.Items[i]));
        v_opts:= v_opts + [v_opt];
      end;
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).AutoOptions:= v_opts;
end;

procedure TojVirtualDrawTreeDesignForm.chAutoOptionsListMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
var v_idx: Integer;
    v_opt: TVTAutoOption;
begin
  v_idx:= chAutoOptionsList.ItemAtPos(Point(X, Y), TRUE);
  if v_idx >= 0  then
    begin
      v_opt:= TVTAutoOption(GetEnumValue(TypeInfo(TVTAutoOption), chAutoOptionsList.Items[v_idx]));
      //  lblInfo.Caption:= VTAutoOptionDescriptions[v_opt];
      lblInfo.Caption:= chAutoOptionsList.Items[v_idx] + ':' + sLineBreak +
                        VTAutoOptionDescriptions[v_opt];
    end
  else
    lblInfo.Caption:= '';
end;

procedure TojVirtualDrawTreeDesignForm.chMiscOptionsListClickCheck(Sender: TObject);
var v_opt: TVTMiscOption;
    v_opts: TVTMiscOptions;
    v_tree: TFakeCustomVirtualDrawTree;
    i: integer;
begin
  v_opts:= [];
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  for i:= 0 to chMiscOptionsList.Items.Count-1 do
    if chMiscOptionsList.Checked[i] then
      begin
        v_opt:= TVTMiscOption(GetEnumValue(TypeInfo(TVTMiscOption), chMiscOptionsList.Items[i]));
        v_opts:= v_opts + [v_opt];
      end;
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).MiscOptions:= v_opts;
end;

procedure TojVirtualDrawTreeDesignForm.chMiscOptionsListMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
var v_idx: Integer;
    v_opt: TVTMiscOption;
begin
  v_idx:= chMiscOptionsList.ItemAtPos(Point(X, Y), TRUE);
  if v_idx >= 0  then
    begin
      v_opt:= TVTMiscOption(GetEnumValue(TypeInfo(TVTMiscOption), chMiscOptionsList.Items[v_idx]));
      //  lblInfo.Caption:= VTAutoOptionDescriptions[v_opt];
      lblInfo.Caption:= chMiscOptionsList.Items[v_idx] + ':' + sLineBreak +
                        VTMiscOptionDescriptions[v_opt];
    end
  else
    lblInfo.Caption:= '';
end;

procedure TojVirtualDrawTreeDesignForm.chPaintOptionsListClickCheck(Sender: TObject);
var v_opt: TVTPaintOption;
    v_opts: TVTPaintOptions;
    v_tree: TFakeCustomVirtualDrawTree;
    i: integer;
begin
  v_opts:= [];
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  for i:= 0 to chPaintOptionsList.Items.Count-1 do
    if chPaintOptionsList.Checked[i] then
      begin
        v_opt:= TVTPaintOption(GetEnumValue(TypeInfo(TVTPaintOption), chPaintOptionsList.Items[i]));
        v_opts:= v_opts + [v_opt];
      end;
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).PaintOptions:= v_opts;
end;

procedure TojVirtualDrawTreeDesignForm.chPaintOptionsListMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
var v_idx: Integer;
    v_opt: TVTPaintOption;
begin
  v_idx:= chPaintOptionsList.ItemAtPos(Point(X, Y), TRUE);
  if v_idx >= 0  then
    begin
      v_opt:= TVTPaintOption(GetEnumValue(TypeInfo(TVTPaintOption), chPaintOptionsList.Items[v_idx]));
      //  lblInfo.Caption:= VTAutoOptionDescriptions[v_opt];
      lblInfo.Caption:= chPaintOptionsList.Items[v_idx] + ':' + sLineBreak +
                        VTPaintOptionDescriptions[v_opt];
    end
  else
    lblInfo.Caption:= '';
end;

procedure TojVirtualDrawTreeDesignForm.chSelectionOptionsListClickCheck(Sender: TObject);
var v_opt: TVTSelectionOption;
    v_opts: TVTSelectionOptions;
    v_tree: TFakeCustomVirtualDrawTree;
    i: integer;
begin
  v_opts:= [];
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  for i:= 0 to chSelectionOptionsList.Items.Count-1 do
    if chSelectionOptionsList.Checked[i] then
      begin
        v_opt:= TVTSelectionOption(GetEnumValue(TypeInfo(TVTSelectionOption), chSelectionOptionsList.Items[i]));
        v_opts:= v_opts + [v_opt];
      end;
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).SelectionOptions:= v_opts;
end;

procedure TojVirtualDrawTreeDesignForm.chSelectionOptionsListMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
var v_idx: Integer;
    v_opt: TVTSelectionOption;
begin
  v_idx:= chSelectionOptionsList.ItemAtPos(Point(X, Y), TRUE);
  if v_idx >= 0  then
    begin
      v_opt:= TVTSelectionOption(GetEnumValue(TypeInfo(TVTSelectionOption), chSelectionOptionsList.Items[v_idx]));
      //  lblInfo.Caption:= VTAutoOptionDescriptions[v_opt];
      lblInfo.Caption:= chSelectionOptionsList.Items[v_idx] + ':' + sLineBreak +
                        VTSelectionOptionDescriptions[v_opt];
    end
  else
    lblInfo.Caption:= '';
end;

constructor TojVirtualDrawTreeDesignForm.Create(AOwner: TComponent; VirtualTree: TojCustomVirtualDrawTree);
begin
  inherited Create(AOwner);
  FVirtualTree:= VirtualTree;
  self.Caption:= 'TVirtualDrawTreeDesignForm: '+ VirtualTree.Name;

  FillAutoOptionsList;
  FillMiscOptionsList;
  FillPaintOptionsList;
  FillSelectionOptionsList;
  FillAnimationOptionsList;
end;

procedure TojVirtualDrawTreeDesignForm.FillAnimationOptionsList;
var v_tree: TFakeCustomVirtualDrawTree;
    v_opt: TVTAnimationOption;
    v_idx: Integer;
begin
  chAnimationOptionsList.Items.Clear;
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  for v_opt:= Low(TVTAnimationOption) to High(TVTAnimationOption) do
    begin
      v_idx:= chAnimationOptionsList.Items.Add( GetEnumName(TypeInfo(TVTAnimationOption), Integer(v_opt)) );
      chAnimationOptionsList.Checked[v_idx]:= (v_opt in TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).AnimationOptions);
    end;
end;

procedure TojVirtualDrawTreeDesignForm.FillAutoOptionsList;
var v_tree: TFakeCustomVirtualDrawTree;
    v_opt: TVTAutoOption;
    v_idx: Integer;
begin
  chAutoOptionsList.Items.Clear;
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  for v_opt:= Low(TVTAutoOption) to High(TVTAutoOption) do
    begin
      v_idx:= chAutoOptionsList.Items.Add( GetEnumName(TypeInfo(TVTAutoOption), Integer(v_opt)) );
      chAutoOptionsList.Checked[v_idx]:= (v_opt in TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).AutoOptions);
    end;
end;

procedure TojVirtualDrawTreeDesignForm.FillMiscOptionsList;
var v_tree: TFakeCustomVirtualDrawTree;
    v_opt: TVTMiscOption;
    v_idx: Integer;
begin
  chMiscOptionsList.Items.Clear;
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  for v_opt:= Low(TVTMiscOption) to High(TVTMiscOption) do
    begin
      v_idx:= chMiscOptionsList.Items.Add( GetEnumName(TypeInfo(TVTMiscOption), Integer(v_opt)) );
      chMiscOptionsList.Checked[v_idx]:= (v_opt in TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).MiscOptions);
    end;
end;

procedure TojVirtualDrawTreeDesignForm.FillPaintOptionsList;
var v_tree: TFakeCustomVirtualDrawTree;
    v_opt: TVTPaintOption;
    v_idx: Integer;
begin
  chPaintOptionsList.Items.Clear;
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  for v_opt:= Low(TVTPaintOption) to High(TVTPaintOption) do
    begin
      v_idx:= chPaintOptionsList.Items.Add( GetEnumName(TypeInfo(TVTPaintOption), Integer(v_opt)) );
      chPaintOptionsList.Checked[v_idx]:= (v_opt in TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).PaintOptions);
    end;
end;

procedure TojVirtualDrawTreeDesignForm.FillSelectionOptionsList;
var v_tree: TFakeCustomVirtualDrawTree;
    v_opt: TVTSelectionOption;
    v_idx: Integer;
begin
  chSelectionOptionsList.Items.Clear;
  v_tree:= TFakeCustomVirtualDrawTree(getVirtualTree);
  for v_opt:= Low(TVTSelectionOption) to High(TVTSelectionOption) do
    begin
      v_idx:= chSelectionOptionsList.Items.Add( GetEnumName(TypeInfo(TVTSelectionOption), Integer(v_opt)) );
      chSelectionOptionsList.Checked[v_idx]:= (v_opt in TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).SelectionOptions);
    end;
end;

function TojVirtualDrawTreeDesignForm.getVirtualTree: TojCustomVirtualDrawTree;
begin
  result:= FVirtualTree;
end;

class procedure TojVirtualDrawTreeDesignForm.ShowDesigner(p_VirtualTree: TojCustomVirtualDrawTree);
var v_form: TojVirtualDrawTreeDesignForm;
begin
  v_form:= TojVirtualDrawTreeDesignForm.Create(nil, p_VirtualTree);
  try
    v_form.ShowModal;
  finally
    FreeAndNil(v_form);
  end;
end;

end.
