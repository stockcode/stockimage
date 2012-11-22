unit u_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,jpeg, ExtCtrls, DB, ADODB,ShellAPI, StrUtils;

type
  TfrmMain = class(TForm)
    conn: TADOConnection;
    ds: TADODataSet;
    tmr: TTimer;
    mmo: TMemo;
    procedure btn1Click(Sender: TObject);
    procedure tmrTimer(Sender: TObject);
    procedure StartWeiTuo();
    procedure FormCreate(Sender: TObject);
    function GetWindowHWND(Caption: String): HWND;
    function GetText(h: HWND): String;
    function GetDialog(Caption: String): String;
    procedure sendKeys(keys: String);
    procedure handlelimit(limittype:string);
  private
    { Private declarations }
  public
    { Public declarations }
    function CaptureScreen(AFileName:String):string;
  end;

var
  frmMain: TfrmMain;
  title:String;
  
implementation

{$R *.dfm}

procedure TfrmMain.btn1Click(Sender: TObject);
begin
CaptureScreen('c:\1.jpg');
end;

function TfrmMain.CaptureScreen(AFileName:String):string;
var
VBmp: TBitmap;
MyJPEG:TJPEGImage;
begin
VBmp := TBitmap.Create;
try
VBmp.Width := Screen.Width;
VBmp.Height := Screen.Height;
BitBlt(VBmp.Canvas.Handle, 0, 0, Screen.Width, Screen.Height, GetDC(0), 0,0, SRCCOPY); //www.delphitop.com
MyJPEG:=TJPEGImage.Create;
MyJPEG.Assign(VBmp);
MyJPEG.CompressionQuality:=100;
MyJPEG.Compress;
MyJPEG.SaveToFile(AFileName);
finally
MyJPEG.Free;
VBmp.Free; 
end; 
end;

procedure TfrmMain.tmrTimer(Sender: TObject);
var
  h:HWND;
begin
  tmr.Enabled := false;
  StartWeiTuo();
  handlelimit('stocklimit');
  handlelimit('stocknotlimit');
  Sleep(3000);
  h:=GetWindowHWND(title);
  postmessage(h,WM_CLOSE,0,0);
  Sleep(2000);
  GetDialog('退出确认');
  Sleep(2000);
  GetDialog('TdxW');
  Sleep(1000);
  close;
end;

procedure TfrmMain.StartWeiTuo;
var
  h,h1,h2,h4:HWND;
  n,retry:Integer;
  xiadanPath:Pchar;
begin
  retry := 0;
  xiadanPath := 'C:\new_gxzq_v6\tdxw.exe';
  h:=GetWindowHWND(title);

  if (h = 0) then begin
    ShellExecute(Handle, 'open', xiadanPath, nil, nil, SW_SHOWNORMAL) ;
    sleep(3000);
    h:=GetWindowHWND(title);
    h1:=FindWindowEx(h,0,'SafeEdit', nil);
    h1 := GetWindow(h1, GW_HWNDNEXT);
    h1 := GetWindow(h1, GW_HWNDNEXT);
    h1 := GetWindow(h1, GW_HWNDNEXT);

    postmessage(h1,WM_LBUTTONDOWN,0,0); //按下鼠标
    postmessage(h1,WM_LBUTTONUP,0,0);  //释放鼠标
    Sleep(5000);
    GetDialog('国信证券股份有限公司');
  end;

  h:=GetWindowHWND(title);
  setforegroundwindow(h);

  while GetWindowHWND(title) = 0 do
  begin
    sleep(10000);
    if (retry > 3) then
    begin
      //SendMail('股票: 下单程序启动失败，无法完成交易', '下单程序地址：' + xiadanPath);
      Close;
    end;
    inc(retry);
  end;
  Sleep(3000);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
 title := '国信金太阳网上交易专业版';
end;

function TfrmMain.GetText(h: HWND): String;
var
  Caption: PChar;
  CaptionLength :Integer;
begin
  CaptionLength := SendMessage(h, WM_GETTEXTLENGTH, 0, 0) + 1;
  getmem(Caption,CaptionLength);
  sendmessage(h,WM_GETTEXT,CaptionLength,integer(Caption));
  result := Caption;
end;

function TfrmMain.GetDialog(Caption: String): String;
var
  h,h1,child,yesBtn, closeBtn:HWND;
  pCaption: PChar;
  CaptionLength :Integer;
begin
  Result := '';
   h := FindWindowEx(0,0,'#32770', PChar(caption));

   yesBtn := FindWindowEx(h,0,'Button', '关闭');

   if yesBtn = 0 then yesBtn := FindWindowEx(h,0,'Button', '退出');

   if yesBtn = 0 then yesBtn := FindWindowEx(h,0,'Button', '否(&N)');

        postmessage(yesBtn,WM_LBUTTONDOWN,0,0);
        postmessage(yesBtn,WM_LBUTTONUP,0,0);

end;

procedure TfrmMain.sendKeys(keys: String);
var
  i:Integer;
  key:byte;
begin
For i := 1 to Length(keys) do begin
  key := byte(keys[i]);
  keybd_event(key, 0, 0 ,0);
  Sleep(100);
end;

  Sleep(1000);
  keybd_event(vk_return, 0, 0 ,0);

end;

function TfrmMain.GetWindowHWND(Caption: String): HWND;
var
  h:HWND;
  title:String;

begin
  h := FindWindowEx(0,0,'#32770', nil);

      while (h <> 0) do begin
        title := GetText(h);

        if AnsiStartsText(Caption, title) then begin
        result := h;
        exit;
      end;

        h := GetWindow(h,GW_HWNDNEXT);
     end;

     result := 0;
end;
procedure TfrmMain.handlelimit(limittype: string);
var
  dir, tradedate, stockcode:String;
  AFormat: TFormatSettings;
begin
  AFormat.ShortDateFormat := 'yyyy-mm-dd';
  tradedate := DateToStr(now, AFormat);
  dir := 'E:\我的微盘\股票\涨停板\' + limittype + '\' + tradedate + '\';
  ForceDirectories(dir);

  ds.Active := False;
  ds.CommandText := 'select * from ' + limittype +' where limitdate=' + QuotedStr(tradedate);
  ds.Active := true;

  while not ds.Eof do begin
    stockcode := ds.FieldByName('stockcode').AsString;
    mmo.Lines.Add(stockcode);
    sendKeys(stockcode);
    sleep(1000);
    keybd_event(VK_NUMPAD9, 0, 0 ,0);
    Sleep(100);
    keybd_event(VK_NUMPAD6, 0, 0 ,0);
    Sleep(1000);
    keybd_event(VK_RETURN, 0, 0 ,0);
    sleep(1000);
    CaptureScreen(dir + stockcode + '_day.jpg');
    sleep(1000);
    keybd_event(VK_F5, 0, 0 ,0);
    sleep(1000);
    CaptureScreen(dir + stockcode + '_min.jpg');
    sleep(1000);
    ds.next;
  end;
  ds.Active := false;
end;

end.
