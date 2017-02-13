object MainForm: TMainForm
  Left = 717
  Top = 268
  BiDiMode = bdLeftToRight
  Caption = 'Simple Virtual Treeview demo; OJ'
  ClientHeight = 429
  ClientWidth = 736
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  ParentBiDiMode = False
  OnCreate = FormCreate
  DesignSize = (
    736
    429)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 12
    Width = 116
    Height = 13
    Caption = 'Last operation duration:'
  end
  object ClearButton: TButton
    Left = 97
    Top = 396
    Width = 129
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Clear tree'
    TabOrder = 0
    OnClick = ClearButtonClick
  end
  object AddOneButton: TButton
    Left = 96
    Top = 336
    Width = 130
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Add node(s) to root'
    TabOrder = 1
    OnClick = AddButtonClick
  end
  object Edit1: TEdit
    Left = 8
    Top = 336
    Width = 81
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    Text = '1'
  end
  object Button1: TButton
    Tag = 1
    Left = 96
    Top = 364
    Width = 130
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Add node(s) as children'
    TabOrder = 3
    OnClick = AddButtonClick
  end
  object CloseButton: TButton
    Left = 657
    Top = 396
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    TabOrder = 5
    OnClick = CloseButtonClick
  end
  object Button2: TButton
    Left = 265
    Top = 336
    Width = 129
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'ResetRoot'
    TabOrder = 4
    OnClick = Button2Click
  end
  object VST: TojVirtualStringTree
    Left = 8
    Top = 31
    Width = 592
    Height = 299
    ParentCustomHint = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'Tahoma'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    RootNodeCount = 55
    TabOrder = 6
    OnFreeNode = VSTFreeNode
    OnGetCellText = VSTGetCellText
    OnGetText = VSTGetText
    OnInitNode = VSTInitNode
    _UserDataClassName = 'TojStringData'
    _OnGetNodeUserDataClass = VST_OnGetNodeUserDataClass
    Columns = <
      item
        Position = 0
        Width = 128
        WideText = 'raz'
        WideFieldName = 'sia'#322'a'
      end
      item
        Position = 1
        Width = 129
        WideText = 'dwa'
        WideFieldName = 'baba'
      end
      item
        Position = 2
        Width = 210
        WideText = 'trzy'
        WideFieldName = 'mak'
      end>
  end
  object btnSaveToStream: TButton
    Left = 606
    Top = 31
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Save To Stream'
    TabOrder = 7
    OnClick = btnSaveToStreamClick
  end
  object btnLoadFromStream: TButton
    Left = 606
    Top = 62
    Width = 105
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Load From Stream'
    TabOrder = 8
    OnClick = btnLoadFromStreamClick
  end
end
