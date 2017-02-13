object ojVirtualDrawTreeDesignForm: TojVirtualDrawTreeDesignForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 397
  ClientWidth = 785
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    785
    397)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 70
    Width = 60
    Height = 13
    Caption = 'AutoOptions'
  end
  object Label2: TLabel
    Left = 584
    Top = 70
    Width = 57
    Height = 13
    Caption = 'MiscOptions'
  end
  object Label3: TLabel
    Left = 392
    Top = 70
    Width = 61
    Height = 13
    Caption = 'PaintOptions'
  end
  object Label4: TLabel
    Left = 200
    Top = 70
    Width = 80
    Height = 13
    Caption = 'SelectionOptions'
  end
  object lblInfo: TLabel
    Left = 11
    Top = 8
    Width = 557
    Height = 49
    AutoSize = False
    Caption = '     '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label5: TLabel
    Left = 8
    Top = 309
    Width = 84
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'AnimationOptions'
  end
  object chAutoOptionsList: TCheckListBox
    Left = 8
    Top = 89
    Width = 177
    Height = 189
    OnClickCheck = chAutoOptionsListClickCheck
    ItemHeight = 13
    TabOrder = 0
    OnMouseMove = chAutoOptionsListMouseMove
  end
  object chMiscOptionsList: TCheckListBox
    Left = 584
    Top = 89
    Width = 177
    Height = 300
    OnClickCheck = chMiscOptionsListClickCheck
    ItemHeight = 13
    TabOrder = 1
    OnMouseMove = chMiscOptionsListMouseMove
  end
  object chPaintOptionsList: TCheckListBox
    Left = 392
    Top = 89
    Width = 177
    Height = 300
    OnClickCheck = chPaintOptionsListClickCheck
    ItemHeight = 13
    TabOrder = 2
    OnMouseMove = chPaintOptionsListMouseMove
  end
  object chSelectionOptionsList: TCheckListBox
    Left = 200
    Top = 89
    Width = 177
    Height = 300
    OnClickCheck = chSelectionOptionsListClickCheck
    ItemHeight = 13
    TabOrder = 3
    OnMouseMove = chSelectionOptionsListMouseMove
  end
  object chAnimationOptionsList: TCheckListBox
    Left = 8
    Top = 328
    Width = 177
    Height = 61
    OnClickCheck = chAnimationOptionsListClickCheck
    ItemHeight = 13
    TabOrder = 4
    OnMouseMove = chAnimationOptionsListMouseMove
  end
  object btnRestoreAutoOptions: TButton
    Left = 128
    Top = 70
    Width = 57
    Height = 17
    Caption = 'restore'
    TabOrder = 5
    OnClick = btnRestoreAutoOptionsClick
  end
  object btnRestoreSelectionOptions: TButton
    Left = 320
    Top = 70
    Width = 57
    Height = 17
    Caption = 'restore'
    TabOrder = 6
    OnClick = btnRestoreSelectionOptionsClick
  end
  object btnRestorePaintOptions: TButton
    Left = 511
    Top = 70
    Width = 57
    Height = 17
    Caption = 'restore'
    TabOrder = 7
    OnClick = btnRestorePaintOptionsClick
  end
  object btnRestoreMiscOptions: TButton
    Left = 704
    Top = 70
    Width = 57
    Height = 17
    Caption = 'restore'
    TabOrder = 8
    OnClick = btnRestoreMiscOptionsClick
  end
  object btnRestoreAnimationOptions: TButton
    Left = 128
    Top = 305
    Width = 57
    Height = 17
    Caption = 'restore'
    TabOrder = 9
    OnClick = btnRestoreAnimationOptionsClick
  end
end
