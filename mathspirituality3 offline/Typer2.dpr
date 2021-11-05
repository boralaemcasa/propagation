program Typer2;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows, Messages;

var
  HWindow: THandle;
  HMemo: THandle;
  f: TextFile;
  s: string;
  i: byte;
begin
  fileMode := 0;
  assignFile(f, 'entrada de dados nea 63 2016.txt');
  reset(f);

  HWindow := FindWindow(nil, 'pw3270 - bhmvsb.prodemge.gov.br:23');
  HMemo := GetWindow(HWindow, GW_CHILD);
  if HMemo <> 0 then
  begin

    while not eof(f) do
    begin
      readln(f, s);
      for i := 1 to 8 do
      begin
         PostMessage(HMemo, WM_KEYDOWN, integer(s[i]), MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
         sleep(200);
      end;

      PostMessage(HMemo, WM_KEYDOWN, vk_return, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(200);
      PostMessage(HMemo, WM_KEYDOWN, vk_tab, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(200);
      PostMessage(HMemo, WM_KEYDOWN, vk_tab, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(200);

      for i := 10 to 15 do
      begin
         PostMessage(HMemo, WM_KEYDOWN, integer(s[i]), MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
         sleep(200);
      end;
      sleep(200);
      PostMessage(HMemo, WM_KEYDOWN, vk_return, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(200);
      PostMessage(HMemo, WM_KEYDOWN, vk_return, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(200);
      PostMessage(HMemo, WM_KEYDOWN, vk_return, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(200);
      PostMessage(HMemo, WM_KEYDOWN, integer('S'), MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(200);
      PostMessage(HMemo, WM_KEYDOWN, vk_return, MakeLong(0, MapVirtualKey(VK_SPACE, 0)));
      sleep(200);
      if fileExists('a.a') then
        break;
    end;
  end;

  closeFile(f);
end.
