{*******************************************************************************
  作者: dmzn@163.com 2009-6-17
  描述: 美容师管理
*******************************************************************************}
unit UFormProduct;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, 
  cxMemo, cxTextEdit, cxDropDownEdit, cxContainer, cxEdit, cxMaskEdit,
  cxCalendar, cxGraphics, cxMCListBox, cxImage, cxButtonEdit;

type
  TfFormProduct = class(TfFormNormal)
    EditPlant: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    EditName: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item6: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    InfoItems: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayout1Item9: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item10: TdxLayoutItem;
    ListInfo1: TcxMCListBox;
    dxLayout1Item11: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditID: TcxButtonEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayout1Item13: TdxLayoutItem;
    ImagePic: TcxImage;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    EditProvider: TcxComboBox;
    dxLayout1Item14: TdxLayoutItem;
    EditPrice: TcxTextEdit;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group6: TdxLayoutGroup;
    EditInfo: TcxMemo;
    dxLayout1Item16: TdxLayoutItem;
    dxLayout1Group8: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ImagePicDblClick(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
  protected
    FRecordID: string;
    //标识
    FPrefixID: string;
    //前缀编号
    FIDLength: integer;
    //前缀长度
    FImageFile: string;
    //照片文件
    FDataInfoChanged: Boolean;
    //数据变动
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //基类方法
    procedure InitFormData(const nID: string);
    //初始化数据
    procedure GetData(Sender: TObject; var nData: string);
    //获取数据
    function SetData(Sender: TObject; const nData: string): Boolean;
    //设置数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, UMgrControl, UAdjustForm, UFormCtrl, ULibFun, UDataModule, 
  UFormBase, USysFun, USysGrid, USysConst, USysDB;

var
  gForm: TfFormProduct = nil;
  
//------------------------------------------------------------------------------
class function TfFormProduct.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormProduct.Create(Application) do
    begin
      FRecordID := '';
      Caption := '产品 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormProduct.Create(Application) do
    begin
      FRecordID := nP.FParamA;
      Caption := '产品 - 修改';

      InitFormData(FRecordID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormProduct.Create(Application);
        gForm.Caption := '产品 - 查看';

        gForm.BtnOK.Visible := False;
        gForm.BtnAdd.Enabled := False;
        gform.BtnDel.Enabled := False;
      end;

      with gForm do
      begin
        FRecordID := nP.FParamA;
        InitFormData(FRecordID);
        if not gForm.Showing then gForm.Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormProduct.FormID: integer;
begin
  Result := cFI_FormProduct;
end;

procedure TfFormProduct.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self);
    LoadMCListBoxConfig(Name, ListInfo1);

    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'CP');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;

  AdjustCtrlData(Self);
  ResetHintAllCtrl(Self, 'T', sTable_Product);
end;

procedure TfFormProduct.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self);
    SaveMCListBoxConfig(Name, ListInfo1);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
procedure TfFormProduct.GetData(Sender: TObject; var nData: string);
begin

end;

function TfFormProduct.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;
end;

procedure TfFormProduct.InitFormData(const nID: string);
var nStr: string;
begin
  if InfoItems.Properties.Items.Count < 1 then
  begin
    InfoItems.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_ProductItem)]);
    //数据字典中产品信息项

    with FDM.QueryTemp(nStr) do
    begin
      First;

      while not Eof do
      begin
        InfoItems.Properties.Items.Add(FieldByName('D_Value').AsString);
        Next;
      end;
    end;
  end;

  if EditType.Properties.Items.Count < 1 then
  begin
    nStr := 'B_ID=Select B_ID,B_Text From %s Where B_Group=''%s''';
    nStr := Format(nStr, [sTable_BaseInfo, sFlag_ProductType]);

    FDM.FillStringsData(EditType.Properties.Items, nStr, -1, sDunHao);
    AdjustCXComboBoxItem(EditType, False);
  end;

  if EditPlant.Properties.Items.Count < 1 then
  begin
    nStr := 'P_ID=Select P_ID,P_Name From %s';
    nStr := Format(nStr, [sTable_Plant]);

    FDM.FillStringsData(EditPlant.Properties.Items, nStr, -1, sDunHao);
    AdjustCXComboBoxItem(EditPlant, False);
  end;

  if EditProvider.Properties.Items.Count < 1 then
  begin
    nStr := 'P_ID=Select P_ID,P_Name From %s';
    nStr := Format(nStr, [sTable_Provider]);

    FDM.FillStringsData(EditProvider.Properties.Items, nStr, -1, sDunHao);
    AdjustCXComboBoxItem(EditProvider, False);
  end;

  if nID <> '' then
  begin
    FDataInfoChanged := False;
    nStr := 'Select * From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_Product, nID]);
    
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '', SetData);
    FDM.LoadDBImage(FDM.SqlTemp, 'P_Image', ImagePic.Picture);

    ListInfo1.Clear;
    nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                       MI('$Group', sFlag_ProductItem), MI('$ID', nID)]);
    //扩展信息

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := FieldByName('I_Item').AsString + ListInfo1.Delimiter +
                FieldByName('I_Info').AsString;
        ListInfo1.Items.Add(nStr);
        
        Next;
      end;
    end;
  end else
  begin
    FDataInfoChanged := True; //数据变动后会保存
  end;
end;

//------------------------------------------------------------------------------
//Desc: 添加信息项
procedure TfFormProduct.BtnAddClick(Sender: TObject);
begin
  InfoItems.Text := Trim(InfoItems.Text);
  if InfoItems.Text = '' then
  begin
    ListInfo1.SetFocus;
    ShowMsg('请填写 或 选择有效的信息项', sHint); Exit;
  end;

  EditInfo.Text := Trim(EditInfo.Text);
  if EditInfo.Text = '' then
  begin
    EditInfo.SetFocus;
    ShowMsg('请填写有效的信息内容', sHint); Exit;
  end;

  ListInfo1.Items.Add(InfoItems.Text + ListInfo1.Delimiter + EditInfo.Text);
  FDataInfoChanged := True;
end;

//Desc: 删除信息项
procedure TfFormProduct.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
    ShowMsg('请选择要删除的内容', sHint); Exit;
  end;

  nIdx := ListInfo1.ItemIndex;
  ListInfo1.Items.Delete(ListInfo1.ItemIndex);
  FDataInfoChanged := True;

  if nIdx >= ListInfo1.Count then Dec(nIdx);
  ListInfo1.ItemIndex := nIdx;
  ShowMsg('信息项已删除', sHint);
end;

//Desc: 查看信息
procedure TfFormProduct.ListInfo1Click(Sender: TObject);
var nStr: string;
    nPos: integer;
begin
  if ListInfo1.ItemIndex > -1 then
  begin
    nStr := ListInfo1.Items[ListInfo1.ItemIndex];
    nPos := Pos(ListInfo1.Delimiter, nStr);

    InfoItems.Text := Copy(nStr, 1, nPos - 1);
    System.Delete(nStr, 1, nPos + Length(ListInfo1.Delimiter) - 1);
    EditInfo.Text := nStr;
  end;
end;

//Desc: 选择照片
procedure TfFormProduct.ImagePicDblClick(Sender: TObject);
begin
  with TOpenDialog.Create(Application) do
  begin
    Title := '照片';
    FileName := FImageFile;
    Filter := '图片文件|*.bmp;*.png;*.jpg';

    if Execute then FImageFile := FileName;
    Free;
  end;

  if FileExists(FImageFile) then ImagePic.Picture.LoadFromFile(FImageFile);
end;

//Desc: 随机编号
procedure TfFormProduct.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditID.Text := RandomItemID(FPrefixID, FIDLength);
end;

//------------------------------------------------------------------------------   
//Desc: 验证数据
function TfFormProduct.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    Result := EditID.Text <> '';
    nHint := '请填写有效的产品编号';
  end else

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    Result := EditName.Text <> '';
    nHint := '请填写有效的产品名称';
  end else

  if Sender = EditPrice then
  begin
    Result := IsNumber(EditPrice.Text, True);
    nHint := '请填写有效的价格';
  end;
end;

//Desc: 保存数据
procedure TfFormProduct.BtnOKClick(Sender: TObject);
var nList: TStrings;
    i,nCount: integer;
    nStr,nSQL: string;
begin
  if not IsDataValid then Exit;

  if FRecordID = '' then
  begin
    nStr := 'Select Count(*) From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_Product, EditID.Text]);
    //查询编号是否存在

    with FDM.QueryTemp(nStr) do
     if Fields[0].AsInteger > 0 then
     begin
       EditID.SetFocus;
       ShowMsg('该编号的产品已经存在', sHint); Exit;
     end;

     nSQL := MakeSQLByForm(Self, sTable_Product, '', True, GetData);
  end else
  begin
    EditID.Text := FRecordID;
    nStr := 'P_ID=''' + FRecordID + '''';
    nSQL := MakeSQLByForm(Self, sTable_Product, nStr, False, GetData);
  end;

  nList := nil;
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);

    if FileExists(FImageFile) then
    begin
      nStr := 'Select * From %s Where P_ID=''%s''';
      nStr := Format(nStr, [sTable_Product, EditID.Text]);

      FDM.QueryTemp(nStr);
      FDM.SaveDBImage(FDM.SqlTemp, 'P_Image', FImageFile);
    end;

    if FDataInfoChanged then
    begin
      if FRecordID <> '' then
      begin
        nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
        nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_ProductItem, FRecordID]);
        FDM.ExecuteSQL(nSQL);
      end;

      nList := TStringList.Create;
      nCount := ListInfo1.Items.Count - 1;

      nSQL := 'Insert Into %s(I_Group, I_ItemID, I_Item, I_Info) ' +
              'Values(''%s'', ''%s'', ''%s'', ''%s'')';
      //xxxxx

      for i:=0 to nCount do
      begin
        nStr := ListInfo1.Items[i];
        if not SplitStr(nStr, nList, 2, ListInfo1.Delimiter) then Continue;

        nStr := Format(nSQL, [sTable_ExtInfo, sFlag_ProductItem,
                              EditID.Text, nList[0], nList[1]]);
        FDM.ExecuteSQL(nStr);
      end;
    end;

    FreeAndNil(nList);
    FDM.ADOConn.CommitTrans;
    
    ModalResult := mrOK;
    ShowMsg('数据已保存', sHint);
  except
    FreeAndNil(nList);
    FDM.ADOConn.RollbackTrans;
    ShowMsg('数据保存失败', '未知原因');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormProduct, TfFormProduct.FormID);
end.
