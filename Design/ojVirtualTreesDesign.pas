unit ojVirtualTreesDesign;

interface
uses  classes, ojVirtualTrees, DesignEditors, DesignMenus, ColnEdit;

type

  TojVirtualTreeEditor = class(TDefaultEditor)
  protected
    procedure ShowColumnsDesigner;
    procedure ShowTreeDesigner;
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetComponent: TojBaseVirtualTree;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

implementation
uses dialogs, ojVirtualStringTreeDesign, ojVirtualDrawTreeDesign;

type
  TVirtualTreeCast = class(TojBaseVirtualTree);

procedure TojVirtualTreeEditor.Edit;
begin
  ShowColumnsDesigner;
end;

procedure TojVirtualTreeEditor.ExecuteVerb(Index: Integer);
var v_inh, v_local: integer;
begin
  v_inh:= inherited GetVerbCount;
  if Index < v_inh
  then inherited ExecuteVerb(Index)
  else
    begin
      v_local:= Index - v_inh;

      case v_local of
        0: {---};
        1: ShowColumnsDesigner;
        2: ShowTreeDesigner;
      end;
    end;

  Designer.Modified;
end;

function TojVirtualTreeEditor.GetComponent: TojBaseVirtualTree;
begin
  result:= TojBaseVirtualTree(inherited GetComponent);
end;

function TojVirtualTreeEditor.GetVerb(Index: Integer): string;
var v_inh, v_local: integer;
begin
  v_inh:= inherited GetVerbCount;
  if Index < v_inh
  then result:= inherited GetVerb(Index)
  else
    begin
      v_local:= Index - v_inh;
      case v_local of
        0: result:= '-';
        1: result:= 'Columns';
        2: result:= 'Advanced';
      end;
    end;

end;

function TojVirtualTreeEditor.GetVerbCount: Integer;
begin
  result:= (inherited GetVerbCount) + 3;
end;

procedure TojVirtualTreeEditor.ShowColumnsDesigner;
begin
  ShowCollectionEditor(Designer, Component, TVirtualTreeCast(Component).Header.Columns, 'Columns');
end;

procedure TojVirtualTreeEditor.ShowTreeDesigner;
begin
  if GetComponent.InheritsFrom(TojCustomVirtualStringTree)
  then TojVirtualStringTreeDesignForm.ShowDesigner(TojCustomVirtualStringTree(GetComponent))
  else if GetComponent.InheritsFrom(TojCustomVirtualDrawTree)
  then TojVirtualDrawTreeDesignForm.ShowDesigner(TojCustomVirtualDrawTree(GetComponent));
end;

end.
