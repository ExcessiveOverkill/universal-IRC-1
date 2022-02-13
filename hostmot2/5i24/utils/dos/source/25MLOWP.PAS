{m25pxx serial eeprom access stuff }
const

ComLength    = 8;
AddLength    = 24;
DataLength   = 8;

{ Instructions }
WriteEnaCom   = $06;
WriteDisCom  = $04;
ReadStatCom  = $05;
WriteStatCom = $01;
ReadCom      = $03;
PageProgCom  = $02;
SectorEraCom = $D8;
BulkEraCom   = $C7;
PowerDown    = $B9;
ReadIDCom    = $AB;

{ status Reg Bits }
WIP = $01;
WEL = $02;
BP0 = $04;
BP1 = $08;
SRWD = $80;

OneMegID = $10;
TwoMegID = $11;
FourMegID = $12;
EightMegID = $13;
SixteenMegID = $14;

type

PageBufferType = array[0..255] of byte;
PageBufferPointer = ^PageBufferType;


{
procedure SetCSHigh;
begin
end;

procedure SetCSLow;
begin
end;



procedure LDisableInterrupts;
begin
  inline($FA);
end;

procedure LEnableInterrupts;
begin
  inline($FB);
end;
}
procedure PutByte25(data: byte);
begin
  SendSPIByte(data);
end;

function GetByte25 : byte;
begin
  Getbyte25 := RecvSPIByte(0);
end;

procedure PutAddress25(add : longint);
begin
  PutByte25(WordRec(LongIntRec(add).HighWord).LowByte);
  PutByte25(WordRec(LongIntRec(add).LowWord).HighByte);
  PutByte25(WordRec(LongIntRec(add).LowWord).LowByte);
end;

procedure Prefix25;
begin
  SetCSLow;
end;

procedure Suffix25;
begin
  SetCSHigh;
end;

function ReadByte25(add: longint) : byte;
begin
  Prefix25;
  PutByte25(ReadCom);
  PutAddress25(add);
  ReadByte25 := GetByte25;
  Suffix25;
end;

function ReadStatus25 : byte;
begin
  Prefix25;
  PutByte25(ReadStatCom);
  ReadStatus25 := GetByte25;
  Suffix25;
end;

function ReadID25: byte;
begin
  Prefix25;
  PutByte25(ReadIDCom);
  PutAddress25(0); { three dummy bytes}
  ReadID25 := GetByte25;
  Suffix25;
end;

procedure WriteEnable25;
begin
  Prefix25;
  PutByte25(WriteEnaCom);
  Suffix25;
end;

procedure WaitForWrite25;
begin
  while (ReadStatus25 and WIP) <> 0 do;
end;

procedure WriteByte25(add : longint; data : byte);
begin
  WriteEnable25;
  Prefix25;
  PutByte25(PageProgCom);
  PutAddress25(add);
  PutByte25(data);
  Suffix25;
  WaitForWrite25;
end;

procedure WritePage25(add : longint; pageBuf : PageBufferPointer);
var
index : word;
begin
  WriteEnable25;
  Prefix25;
  PutByte25(PageProgCom);
  PutAddress25(add); { note that add 0..7 should be 0}
  for index := 0 to 255 do
  begin
    PutByte25(PageBuf^[index]);
  end;
  Suffix25;
  WaitForWrite25;
end;

procedure EraseChip25;
begin
  WriteEnable25;
  Prefix25;
  PutByte25(BulkEraCom);
  Suffix25;
  WaitForWrite25;
end;

procedure EraseSector25(add: longint);
begin
  WriteEnable25;
  Prefix25;
  PutByte25(SectorEraCom);
  PutAddress25(add);
  Suffix25;
  WaitForWrite25;
end;
