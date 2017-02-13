unit ojVirtualStringTreeDesign;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ojVirtualTrees, StdCtrls, CheckLst;

type
  TojVirtualStringTreeDesignForm = class(TForm)
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
    chStringOptionsList: TCheckListBox;
    Label6: TLabel;
    btnRestoreAutoOptions: TButton;
    btnRestoreSelectionOptions: TButton;
    btnRestorePaintOptions: TButton;
    btnRestoreMiscOptions: TButton;
    btnRestoreAnimationOptions: TButton;
    btnRestoreStringOptions: TButton;
    procedure chAutoOptionsListClickCheck(Sender: TObject);
    procedure chMiscOptionsListClickCheck(Sender: TObject);
    procedure chPaintOptionsListClickCheck(Sender: TObject);
    procedure chSelectionOptionsListClickCheck(Sender: TObject);
    procedure chAutoOptionsListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure chAnimationOptionsListClickCheck(Sender: TObject);
    procedure chStringOptionsListClickCheck(Sender: TObject);
    procedure chAnimationOptionsListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure chStringOptionsListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure chMiscOptionsListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure chPaintOptionsListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure chSelectionOptionsListMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure btnRestoreAutoOptionsClick(Sender: TObject);
    procedure btnRestoreSelectionOptionsClick(Sender: TObject);
    procedure btnRestorePaintOptionsClick(Sender: TObject);
    procedure btnRestoreMiscOptionsClick(Sender: TObject);
    procedure btnRestoreAnimationOptionsClick(Sender: TObject);
    procedure btnRestoreStringOptionsClick(Sender: TObject);
  private
    FVirtualTree: TojCustomVirtualStringTree;
  protected
    procedure FillAutoOptionsList;
    procedure FillMiscOptionsList;
    procedure FillPaintOptionsList;
    procedure FillSelectionOptionsList;
    procedure FillStringOptionsList;
    procedure FillAnimationOptionsList;
  public
    constructor Create(AOwner: TComponent; VirtualTree: TojCustomVirtualStringTree);reintroduce;overload;virtual;

    function getVirtualTree: TojBaseVirtualTree;
  public
    class procedure ShowDesigner(p_VirtualTree: TojCustomVirtualStringTree);
  end;


implementation
uses typInfo;
{$R *.dfm}
type
  TFakeCustomVirtualStringTree = class(TojCustomVirtualStringTree);
  TFakeCustomVirtualTreeOptions = class(TCustomVirtualTreeOptions);
  TFakeCustomStringTreeOptions = class(TCustomStringTreeOptions);
{ TVirtualStringTreeDesignForm }

procedure TojVirtualStringTreeDesignForm.btnRestoreAnimationOptionsClick(Sender: TObject);
var v_tree: TFakeCustomVirtualStringTree;
begin
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).AnimationOptions:= DefaultAnimationOptions;
  FillAnimationOptionsList;
end;

procedure TojVirtualStringTreeDesignForm.btnRestoreAutoOptionsClick(Sender: TObject);
var v_tree: TFakeCustomVirtualStringTree;
begin
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).AnimationOptions:= DefaultAnimationOptions;
  FillAutoOptionsList;
end;

procedure TojVirtualStringTreeDesignForm.btnRestoreMiscOptionsClick(Sender: TObject);
var v_tree: TFakeCustomVirtualStringTree;
begin
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).MiscOptions:= DefaultMiscOptions;
  FillMiscOptionsList;
end;

procedure TojVirtualStringTreeDesignForm.btnRestorePaintOptionsClick(Sender: TObject);
var v_tree: TFakeCustomVirtualStringTree;
begin
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).PaintOptions:= DefaultPaintOptions;
  FillPaintOptionsList;
end;

procedure TojVirtualStringTreeDesignForm.btnRestoreSelectionOptionsClick(Sender: TObject);
var v_tree: TFakeCustomVirtualStringTree;
begin
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).SelectionOptions:= DefaultSelectionOptions;
  FillSelectionOptionsList;
end;

procedure TojVirtualStringTreeDesignForm.btnRestoreStringOptionsClick(Sender: TObject);
var v_tree: TFakeCustomVirtualStringTree;
begin
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  TFakeCustomStringTreeOptions(TFakeCustomVirtualTreeOptions(v_tree.TreeOptions)).StringOptions:= DefaultStringOptions;
  FillStringOptionsList;
end;

procedure TojVirtualStringTreeDesignForm.chAnimationOptionsListClickCheck(Sender: TObject);
var v_opt: TVTAnimationOption;
    v_opts: TVTAnimationOptions;
    v_tree: TFakeCustomVirtualStringTree;
    i: integer;
begin
  v_opts:= [];
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  for i:= 0 to chAnimationOptionsList.Items.Count-1 do
    if chAnimationOptionsList.Checked[i] then
      begin
        v_opt:= TVTAnimationOption(GetEnumValue(TypeInfo(TVTAnimationOption), chAnimationOptionsList.Items[i]));
        v_opts:= v_opts + [v_opt];
      end;
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).AnimationOptions:= v_opts;
end;

procedure TojVirtualStringTreeDesignForm.chAnimationOptionsListMouseMove(
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

procedure TojVirtualStringTreeDesignForm.chAutoOptionsListClickCheck(Sender: TObject);
var v_opt: TVTAutoOption;
    v_opts: TVTAutoOptions;
    v_tree: TFakeCustomVirtualStringTree;
    i: integer;
begin
  v_opts:= [];
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  for i:= 0 to chAutoOptionsList.Items.Count-1 do
    if chAutoOptionsList.Checked[i] then
      begin
        v_opt:= TVTAutoOption(GetEnumValue(TypeInfo(TVTAutoOption), chAutoOptionsList.Items[i]));
        v_opts:= v_opts + [v_opt];
      end;
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).AutoOptions:= v_opts;
end;

procedure TojVirtualStringTreeDesignForm.chAutoOptionsListMouseMove(
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

procedure TojVirtualStringTreeDesignForm.chMiscOptionsListClickCheck(Sender: TObject);
var v_opt: TVTMiscOption;
    v_opts: TVTMiscOptions;
    v_tree: TFakeCustomVirtualStringTree;
    i: integer;
begin
  v_opts:= [];
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  for i:= 0 to chMiscOptionsList.Items.Count-1 do
    if chMiscOptionsList.Checked[i] then
      begin
        v_opt:= TVTMiscOption(GetEnumValue(TypeInfo(TVTMiscOption), chMiscOptionsList.Items[i]));
        v_opts:= v_opts + [v_opt];
      end;
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).MiscOptions:= v_opts;
end;

procedure TojVirtualStringTreeDesignForm.chMiscOptionsListMouseMove(
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

procedure TojVirtualStringTreeDesignForm.chPaintOptionsListClickCheck(Sender: TObject);
var v_opt: TVTPaintOption;
    v_opts: TVTPaintOptions;
    v_tree: TFakeCustomVirtualStringTree;
    i: integer;
begin
  v_opts:= [];
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  for i:= 0 to chPaintOptionsList.Items.Count-1 do
    if chPaintOptionsList.Checked[i] then
      begin
        v_opt:= TVTPaintOption(GetEnumValue(TypeInfo(TVTPaintOption), chPaintOptionsList.Items[i]));
        v_opts:= v_opts + [v_opt];
      end;
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).PaintOptions:= v_opts;
end;

procedure TojVirtualStringTreeDesignForm.chPaintOptionsListMouseMove(
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

procedure TojVirtualStringTreeDesignForm.chSelectionOptionsListClickCheck(Sender: TObject);
var v_opt: TVTSelectionOption;
    v_opts: TVTSelectionOptions;
    v_tree: TFakeCustomVirtualStringTree;
    i: integer;
begin
  v_opts:= [];
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  for i:= 0 to chSelectionOptionsList.Items.Count-1 do
    if chSelectionOptionsList.Checked[i] then
      begin
        v_opt:= TVTSelectionOption(GetEnumValue(TypeInfo(TVTSelectionOption), chSelectionOptionsList.Items[i]));
        v_opts:= v_opts + [v_opt];
      end;
  TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).SelectionOptions:= v_opts;
end;

procedure TojVirtualStringTreeDesignForm.chSelectionOptionsListMouseMove(
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

procedure TojVirtualStringTreeDesignForm.chStringOptionsListClickCheck(Sender: TObject);
var v_opt: TVTStringOption;
    v_opts: TVTStringOptions;
    v_tree: TFakeCustomVirtualStringTree;
    i: integer;
begin
  v_opts:= [];
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  for i:= 0 to chStringOptionsList.Items.Count-1 do
    if chStringOptionsList.Checked[i] then
      begin
        v_opt:= TVTStringOption(GetEnumValue(TypeInfo(TVTStringOption), chStringOptionsList.Items[i]));
        v_opts:= v_opts + [v_opt];
      end;
  TFakeCustomStringTreeOptions(TFakeCustomVirtualTreeOptions(v_tree.TreeOptions)).StringOptions:= v_opts;
end;

procedure TojVirtualStringTreeDesignForm.chStringOptionsListMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
var v_idx: Integer;
    v_opt: TVTStringOption;
begin
  v_idx:= chStringOptionsList.ItemAtPos(Point(X, Y), TRUE);
  if v_idx >= 0  then
    begin
      v_opt:= TVTStringOption(GetEnumValue(TypeInfo(TVTStringOption), chStringOptionsList.Items[v_idx]));
      //  lblInfo.Caption:= VTAutoOptionDescriptions[v_opt];
      lblInfo.Caption:= chStringOptionsList.Items[v_idx] + ':' + sLineBreak +
                        VTStringOptionDescriptions[v_opt];
    end
  else
    lblInfo.Caption:= '';
end;

constructor TojVirtualStringTreeDesignForm.Create(AOwner: TComponent; VirtualTree: TojCustomVirtualStringTree);
begin
  inherited Create(AOwner);
  FVirtualTree:= VirtualTree;
  self.Caption:= 'TVirtualStringTreeDesignForm: '+ VirtualTree.Name;

  FillAutoOptionsList;
  FillMiscOptionsList;
  FillPaintOptionsList;
  FillSelectionOptionsList;
  FillStringOptionsList;
  FillAnimationOptionsList;
end;

procedure TojVirtualStringTreeDesignForm.FillAnimationOptionsList;
var v_tree: TFakeCustomVirtualStringTree;
    v_opt: TVTAnimationOption;
    v_idx: Integer;
begin
  chAnimationOptionsList.Items.Clear;
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  for v_opt:= Low(TVTAnimationOption) to High(TVTAnimationOption) do
    begin
      v_idx:= chAnimationOptionsList.Items.Add( GetEnumName(TypeInfo(TVTAnimationOption), Integer(v_opt)) );
      chAnimationOptionsList.Checked[v_idx]:= (v_opt in TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).AnimationOptions);
    end;
end;

procedure TojVirtualStringTreeDesignForm.FillAutoOptionsList;
var v_tree: TFakeCustomVirtualStringTree;
    v_opt: TVTAutoOption;
    v_idx: Integer;
begin
  chAutoOptionsList.Items.Clear;
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  for v_opt:= Low(TVTAutoOption) to High(TVTAutoOption) do
    begin
      v_idx:= chAutoOptionsList.Items.Add( GetEnumName(TypeInfo(TVTAutoOption), Integer(v_opt)) );
      chAutoOptionsList.Checked[v_idx]:= (v_opt in TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).AutoOptions);
    end;
end;

procedure TojVirtualStringTreeDesignForm.FillMiscOptionsList;
var v_tree: TFakeCustomVirtualStringTree;
    v_opt: TVTMiscOption;
    v_idx: Integer;
begin
  chMiscOptionsList.Items.Clear;
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  for v_opt:= Low(TVTMiscOption) to High(TVTMiscOption) do
    begin
      v_idx:= chMiscOptionsList.Items.Add( GetEnumName(TypeInfo(TVTMiscOption), Integer(v_opt)) );
      chMiscOptionsList.Checked[v_idx]:= (v_opt in TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).MiscOptions);
    end;
end;

procedure TojVirtualStringTreeDesignForm.FillPaintOptionsList;
var v_tree: TFakeCustomVirtualStringTree;
    v_opt: TVTPaintOption;
    v_idx: Integer;
begin
  chPaintOptionsList.Items.Clear;
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  for v_opt:= Low(TVTPaintOption) to High(TVTPaintOption) do
    begin
      v_idx:= chPaintOptionsList.Items.Add( GetEnumName(TypeInfo(TVTPaintOption), Integer(v_opt)) );
      chPaintOptionsList.Checked[v_idx]:= (v_opt in TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).PaintOptions);
    end;
end;

procedure TojVirtualStringTreeDesignForm.FillSelectionOptionsList;
var v_tree: TFakeCustomVirtualStringTree;
    v_opt: TVTSelectionOption;
    v_idx: Integer;
begin
  chSelectionOptionsList.Items.Clear;
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  for v_opt:= Low(TVTSelectionOption) to High(TVTSelectionOption) do
    begin
      v_idx:= chSelectionOptionsList.Items.Add( GetEnumName(TypeInfo(TVTSelectionOption), Integer(v_opt)) );
      chSelectionOptionsList.Checked[v_idx]:= (v_opt in TFakeCustomVirtualTreeOptions(v_tree.TreeOptions).SelectionOptions);
    end;
end;

procedure TojVirtualStringTreeDesignForm.FillStringOptionsList;
var v_tree: TFakeCustomVirtualStringTree;
    v_opt: TVTStringOption;
    v_opts: TVTStringOptions;
    v_idx: Integer;
begin
  chStringOptionsList.Items.Clear;
  v_tree:= TFakeCustomVirtualStringTree(getVirtualTree);
  v_opts:= TFakeCustomStringTreeOptions(TFakeCustomVirtualTreeOptions(v_tree.TreeOptions)).StringOptions;
  for v_opt:= Low(TVTStringOption) to High(TVTStringOption) do
    begin
      v_idx:= chStringOptionsList.Items.Add( GetEnumName(TypeInfo(TVTStringOption), Integer(v_opt)) );
      chStringOptionsList.Checked[v_idx]:= (v_opt in v_opts);
    end;

end;

function TojVirtualStringTreeDesignForm.getVirtualTree: TojBaseVirtualTree;
begin
  result:= FVirtualTree;
end;

class procedure TojVirtualStringTreeDesignForm.ShowDesigner(p_VirtualTree: TojCustomVirtualStringTree);
var v_form: TojVirtualStringTreeDesignForm;
begin
  v_form:= TojVirtualStringTreeDesignForm.Create(nil, p_VirtualTree);
  try
    v_form.ShowModal;
  finally
    FreeAndNil(v_form);
  end;
end;

end.
