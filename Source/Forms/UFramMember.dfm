inherited fFrameMember: TfFrameMember
  Width = 691
  Height = 458
  inherited ToolBar1: TToolBar
    Width = 691
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
    inherited BtnExit: TToolButton
      OnClick = BtnExitClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 196
    Width = 691
    Height = 262
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
      OnDblClick = cxView1DblClick
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 691
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = 57
      Top = 93
      Hint = 'T.M_ID'
      ParentFont = False
      TabOrder = 2
      Width = 100
    end
    object cxTextEdit2: TcxTextEdit [1]
      Left = 196
      Top = 93
      Hint = 'T.M_Name'
      ParentFont = False
      TabOrder = 3
      Width = 100
    end
    object cxTextEdit3: TcxTextEdit [2]
      Left = 510
      Top = 93
      Hint = 'T.M_Memo'
      ParentFont = False
      TabOrder = 5
      Width = 100
    end
    object cxTextEdit4: TcxTextEdit [3]
      Left = 347
      Top = 93
      Hint = 'T.M_Beautician'
      ParentFont = False
      TabOrder = 4
      Width = 100
    end
    object EditID: TcxButtonEdit [4]
      Left = 57
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      Width = 100
    end
    object EditName: TcxButtonEdit [5]
      Left = 196
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 1
      Width = 100
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          Caption = #32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #22995#21517':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #32534#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #22995#21517':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #32654#23481#24072':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #22791#27880#20449#24687':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited TitleBar: TcxLabel
    Caption = #20250#21592#31649#29702
    Width = 691
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 234
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 234
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 4
    Top = 262
    object N2: TMenuItem
      Tag = 10
      Caption = #26597#30475#36164#26009
      OnClick = N1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Tag = 20
      Caption = #20250#21592#36807#25143
      OnClick = N1Click
    end
  end
end
