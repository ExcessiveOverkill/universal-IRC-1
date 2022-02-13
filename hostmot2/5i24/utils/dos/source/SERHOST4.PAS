{for fifo'ed 7I60}
{$R-}    {Range checking be off }
{$I-}    {No I/O checking }
{$S-}    {No stack checking}

type buffer = array[1.. FlashBlockSize] of byte; { largest size }
     bufptr = ^buffer;
     DataBuffertype = array[0..255] of word;
     DataBuffPtr = ^DataBuffertype;

var  DataBuffer : DataBuffertype;

{*****************************************************************************}
procedure SerMesaStart;
var
sstring : string;
begin
  SerSetRTSHigh;
  sstring := CR {sync} + SerMesaStartCom + CR;
  SerSendString(sstring);
end;

procedure SerMesaStop;
var
sstring : string;
begin
  SerSetRTSLow;
  sstring := SerMesaStopCom + CR;
  SerSendString(sstring);
end;

procedure SerListen(addr : byte);
var
sstring : string;
begin
  sstring := SerListenCom + HexString(addr,2) + CR;
  SerSendString(sstring);
end;

function InquireID : string;
var
rstring,sstring : string;
retchar : char;
begin
  sstring := SerInquireIDCom +CR;
  SerSendString(sstring);
  SerRecvString(4,rstring);
  if not SerRecvChar(retchar) then SerError := true;
  InquireID := rstring;
end;

function SerProbe(addr : byte) : boolean;
var
sstring : string;
begin
  SerProbe := false;
  SerListen(addr);
  sstring := InquireID;
  if sstring = '3C20' then SerProbe := true;
end;

procedure CloseSerialPort;
begin
{$IFDEF THREEC20}
  SerMesaStop;
{$ENDIF}
  SerClose;
end;
(*
procedure InitializeSerInterface;
begin
  DefaultComInit(TheComPort);
  EnableFifos(TheComPort); { don't check if fifos are there because it sends garbage }
  SetBaudRate(TheComPort,UartBaudrate);
  TossChars(TheComPort,130);
end;
  *)
procedure SerWritePicWord(address:word; data:word);
var
sstring : string;
retchar : char;
begin
  sstring := SerWritePicWordCom+HexString(address,4)+HexString(data,4)+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

function SerReadPicWord(address:word) : word;
var
sstring : string;
retchar : char;
data : word;
begin
  sstring := SerReadPicWordCom+HexString(address,4)+CR;
  SerSendString(sstring);
  SerRecvString(4,sstring);  { get 4 char hex string }
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  HexWordRead(sstring,data);
  SerReadPicWord := data;
end;

procedure SerWriteDirectByte(address:byte; data:byte);
var
sstring : string;
retchar : char;
begin
  sstring := SerWritedirectByteCom+HexString(address,2)+HexString(data,2)+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure SerWriteDirectWord(address:byte; data:word);
var
sstring : string;
retchar : char;
begin
  sstring := SerWritedirectWordCom+HexString(address,2)+HexString(data,4)+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure WriteGroup( group : word;ourbuffer : bufptr);
var
sstring : string;
retchar : char;
index : word;
begin
  sstring := SerWriteGroupCom+ HexString(group,4)+CR;
  SerSendString(sstring);
  for index := 1 to GroupSize do SerSendString(HexString(ourbuffer^[index],2));
  if not SerRecvChar(retchar) then SerError := true;
end;

function SerCountICDFIFO : word;
var
data : word;
rstring,sstring : string;
retchar : char;
begin
  sstring := SerCountICDFIFOCom + CR;
  SerSendString(sstring);
  SerRecvString(4,rstring);  { get 4 char hex string }
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  HexWordRead(rstring,data);
  SerCountICDFIFO := data;
end;
function SerCountIRBFIFO : word;
var
data : word;
rstring,sstring : string;
retchar : char;
begin
  sstring := SerCountIRBFIFOCom + CR;
  SerSendString(sstring);
  SerRecvString(4,rstring);  { get 4 char hex string }
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  HexWordRead(rstring,data);
  SerCountIRBFIFO := data;
end;

function SerCountQCDFIFO : word;
var
data : word;
rstring,sstring : string;
retchar : char;
begin
  sstring := SerCountQCDFIFOCom + CR;
  SerSendString(sstring);
  SerRecvString(4,rstring);  { get 4 char hex string }
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  HexWordRead(rstring,data);
  SerCountQCDFIFO := data;
end;

function SerCountQRBFIFO : word;
var
data : word;
rstring,sstring : string;
retchar : char;
begin
  sstring := SerCountQRBFIFOCom + CR;
  SerSendString(sstring);
  SerRecvString(4,rstring);  { get 4 char hex string }
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  HexWordRead(rstring,data);
  SerCountQRBFIFO := data;
end;

function SerReadIFIFO : word;
var
data : word;
rstring,sstring : string;
retchar : char;
begin
  sstring := SerReadIFIFOCom + CR;
  SerSendString(sstring);
  SerRecvString(4,rstring);  { get 4 char hex string }
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  HexWordRead(rstring,data);
  SerReadIFIFO := data;
end;

procedure SerReadQFIFOMultiple(n : word; bufptr : DataBuffPtr);
var
data : word;
index : byte;
rstring,sstring : string;
retchar : char;
begin
  sstring := SerReadQFIFOMultipleCom + HexString(n,2) + CR;
  SerSendString(sstring);
  for index := 0 to n-1 do
  begin
    SerRecvString(4,rstring);
    HexWordRead(rstring,data);
    bufptr^[index] := data;
  end;
  if not SerRecvChar(retchar) then SerError := true; { get CR }
end;

function SerReadQFIFO : word;
var
data : word;
rstring,sstring : string;
retchar : char;
begin
  sstring := SerReadQFIFOCom + CR;
  SerSendString(sstring);
  SerRecvString(4,rstring);  { get 4 char hex string }
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  HexWordRead(rstring,data);
  SerReadQFIFO := data;
end;

function SerReadDirectByte(address: byte) : byte;
var
data : word;
rstring,sstring : string;
retchar : char;
begin
  sstring := SerReadDirectByteCom + HexString(address,2) +CR;
  SerSendString(sstring);
  SerRecvString(2,rstring);  { get 4 char hex string }
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  HexWordRead(rstring,data);
  SerReadDirectByte := data;
end;

function SerReadDirectWord(address: byte) : word;
var
data : word;
rstring,sstring : string;
retchar : char;
begin
  sstring := SerReadDirectWordCom + HexString(address,2) +CR;
  SerSendString(sstring);
  SerRecvString(4,rstring);  { get 4 char hex string }
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  HexWordRead(rstring,data);
  SerReadDirectWord := data;
end;

function SerReadParamWord(command:word) : word;
var
data : word;
rstring,sstring : string;
retchar : char;
begin
  sstring := SerWriteIFIFOCom + HexString(command,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  sstring := SerReadIFIFOCom + CR;
  SerSendString(sstring);
  SerRecvString(4,rstring);  { get 4 char hex string }
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  HexWordRead(rstring,data);
  SerReadParamWord := data;
end;

function SerReadParam(command:word) : longint;
var
sstring : string;
rlstring : string;
rhstring : string;
ldata : longint;
retchar : char;
begin
  sstring := SerWriteIFIFOCom + HexString(command,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerReadIFIFOCom + CR;
  SerSendString(sstring);
  SerRecvString(4,rlstring);
  if not SerRecvChar(retchar) then SerError := true;
  SerSendString(sstring);
  SerRecvString(4,rhstring);
  if not SerRecvChar(retchar) then SerError := true;
  HexLongRead(rhstring+rlstring,ldata);
  SerReadParam := ldata;
end;

{$IFDEF COPROC}
function SerReadParamDouble(command:word) : comp;
var
sstring : string;
r0string,r1string,r2string,r3string : string;
cdata : comp;
retchar : char;
begin
  sstring := SerWriteIFIFOCom + HexString(command,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerReadIFIFOCom + CR;
  SerSendString(sstring);
  SerRecvString(4,r0string);
  if not SerRecvChar(retchar) then SerError := true;
  SerSendString(sstring);
  SerRecvString(4,r1string);
  if not SerRecvChar(retchar) then SerError := true;
  SerSendString(sstring);
  SerRecvString(4,r2string);
  if not SerRecvChar(retchar) then SerError := true;
  SerSendString(sstring);
  SerRecvString(4,r3string);
  if not SerRecvChar(retchar) then SerError := true;
  HexLongRead(r1string+r0string,DoubleLongRec(cdata).Long0);
  HexLongRead(r3string+r2string,DoubleLongRec(cdata).Long1);
  SerReadParamDouble := cdata;
end;
{$ENDIF}

procedure SerWriteParamWord(command:word;data:word);
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteIFIFOCom+HexString(command,4)+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteIFIFOCom+HexString(data,4)+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure SerWriteCommand(command:word);
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteIFIFOCom+HexString(command,4)+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure SerWriteCommandQ(command:word);
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteQFIFOCom+HexString(command,4)+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure SerWriteParam(command: word;ldata:longint);
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteIFIFOCom + HexString(command,4)+ CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteIFIFOCom + HexString(LongIntRec(ldata).LowWord,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteIFIFOCom + HexString(LongIntRec(ldata).HighWord,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

{$IFDEF COPROC}
procedure SerWriteParamDouble(command: word;cdata:comp);
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteIFIFOCom + HexString(command,4)+ CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteIFIFOCom + HexString(DoubleIntRec(cdata).Word0,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteIFIFOCom + HexString(DoubleIntRec(cdata).Word1,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteIFIFOCom + HexString(DoubleIntRec(cdata).Word2,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteIFIFOCom + HexString(DoubleIntRec(cdata).Word3,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;
{$ENDIF}

function SerReadParamWordQ(command:word) : word;
var
data : word;
rstring,sstring : string;
retchar : char;
begin
  sstring := SerWriteQFIFOCom + HexString(command,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  sstring := SerReadQFIFOCom + CR;
  SerSendString(sstring);
  SerRecvString(4,rstring);  { get 4 char hex string }
  if not SerRecvChar(retchar) then SerError := true; { get CR }
  HexWordRead(rstring,data);
  SerReadParamWordQ := data;
end;

function SerReadParamQ(command:word) : longint;
var
sstring : string;
rlstring : string;
rhstring : string;
ldata : longint;
retchar : char;
begin
  sstring := SerWriteQFIFOCom + HexString(command,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerReadQFIFOCom + CR;
  SerSendString(sstring);
  SerRecvString(4,rlstring);
  if not SerRecvChar(retchar) then SerError := true;
  SerSendString(sstring);
  SerRecvString(4,rhstring);
  if not SerRecvChar(retchar) then SerError := true;
  HexLongRead(rhstring+rlstring,ldata);
  SerReadParamQ := ldata;
end;

{$IFDEF COPROC}
function SerReadParamDoubleQ(command:word) : comp;
var
sstring : string;
r0string,r1string,r2string,r3string : string;
cdata : comp;
retchar : char;
begin
  sstring := SerWriteQFIFOCom + HexString(command,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerReadQFIFOCom + CR;
  SerSendString(sstring);
  SerRecvString(4,r0string);
  if not SerRecvChar(retchar) then SerError := true;
  SerSendString(sstring);
  SerRecvString(4,r1string);
  if not SerRecvChar(retchar) then SerError := true;
  SerSendString(sstring);
  SerRecvString(4,r2string);
  if not SerRecvChar(retchar) then SerError := true;
  SerSendString(sstring);
  SerRecvString(4,r3string);
  if not SerRecvChar(retchar) then SerError := true;
  HexLongRead(r0string+r1string,DoubleLongRec(cdata).Long0);
  HexLongRead(r2string+r3string,DoubleLongRec(cdata).Long1);
  SerReadParamDoubleQ := cdata;
end;
{$ENDIF}
procedure SerWriteParamWordQ(command:word;data:word);
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteQFIFOCom+HexString(command,4)+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteQFIFOCom+HexString(data,4)+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure SerWriteParamQ(command: word;ldata:longint);
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteQFIFOCom + HexString(command,4)+ CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteQFIFOCom + HexString(LongIntRec(ldata).LowWord,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteQFIFOCom + HexString(LongIntRec(ldata).HighWord,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

{$IFDEF COPROC}
procedure SerWriteParamDoubleQ(command: word;cdata:comp);
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteQFIFOCom + HexString(command,4)+ CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteQFIFOCom + HexString(DoubleIntRec(cdata).Word0,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteQFIFOCom + HexString(DoubleIntRec(cdata).Word1,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteQFIFOCom + HexString(DoubleIntRec(cdata).Word2,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  sstring := SerWriteQFIFOCom + HexString(DoubleIntRec(cdata).Word3,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;
{$ENDIF}

procedure ReadGroup( group : word;ourbuffer : bufptr);
var
rstring,sstring : string;
retchar : char;
index : word;
begin
  sstring := SerReadGroupCom+ HexString(group,4)+CR;
  SerSendString(sstring);
  for index := 1 to GroupSize do
  begin
    SerRecvString(2,rstring);
    HexByteRead(rstring,ourbuffer^[index]);
  end;
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure ClearChecksum;
var
sstring : string;
retchar : char;
begin
  sstring := SerEraseChecksumCom+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

function ReadChecksum : byte;
var
rstring,sstring : string;
data : byte;
retchar : char;
begin
  sstring := SerReadChecksumCom + CR;
  SerSendString(sstring);
  SerRecvString(2,rstring);
  if not SerRecvChar(retchar) then SerError := true;
  HexbyteRead(rstring,data);
  ReadChecksum := data;
end;

procedure oldSerUnlock;
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteProtectCom+'00'+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

function SerUnlock : boolean;
var
sstring : string;
retchar : char;
begin
  SerUnlock := false;
  sstring := SerWriteProtectCom+'00'+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  if retchar = CR then SerUnlock := true;
end;

procedure oldSerLock;
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteProtectCom+ 'FF'+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

function SerLock : boolean;
var
sstring : string;
retchar : char;
begin
  SerLock := false;
  sstring := SerWriteProtectCom+ 'FF'+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
  if retchar = CR then SerLock := true;
end;

procedure SerPicGo(address:word);
var
sstring : string;
begin
  SerUnlock;
  sstring := SerPicGoCom+HexString(address,4)+CR;
  SerSendString(sstring);
 { if not SerRecvChar(retchar) then SerError := true;}
end;

procedure SerClearICDFIFO;
var
sstring : string;
retchar : char;
begin
  sstring := SerClearICDFIFOCom+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure SerClearQCDFIFO;
var
sstring : string;
retchar : char;
begin
  sstring := SerClearQCDFIFOCom+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure SerClearIRBFIFO;
var
sstring : string;
retchar : char;
begin
  sstring := SerClearIRBFIFOCom+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure SerClearQRBFIFO;
var
sstring : string;
retchar : char;
begin
  sstring := SerClearQRBFIFOCom+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure WriteFlashBlock( block : byte;ourbuffer : bufptr);
var
sstring : string;
retchar : char;
index : word;
begin
  sstring := SerWriteFlashCom + HexString(block,2)+CR;
  SerSendString(sstring);
  for index := 1 to FlashBlockSize do
  begin
    SerSendString(HexString(ourbuffer^[index],2))
  end;
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure WriteNewFlashBlock( block : word; size : word; ourbuffer : bufptr);
var
sstring : string;
retchar : char;
index : word;
begin
  sstring := SerWriteFlashCom+ HexString(block,4)+CR;
  SerSendString(sstring);
  for index := 1 to size do
  begin
    SerSendString(HexString(ourbuffer^[index],2));
  end;
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure EraseFlashBlock( block : byte);
var
sstring : string;
retchar : char;
begin
  sstring := SerEraseFlashCom+ HexString(block,2)+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure ReadFlashBlock( block : byte;ourbuffer : bufptr);
var
rstring,sstring : string;
retchar : char;
index : word;
begin
  sstring := SerReadFlashCom+ HexString(block,2)+CR;
  SerSendString(sstring);
  for index := 1 to FlashBlockSize do
  begin
    SerRecvString(2,rstring);
    HexByteRead(rstring,ourbuffer^[index]);
  end;
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure ReadNewFlashBlock( block : byte; size : word; ourbuffer : bufptr);
var
rstring,sstring : string;
retchar : char;
index : word;
begin
  sstring := SerReadFlashCom+ HexString(block,4)+CR;
  SerSendString(sstring);
  for index := 1 to size do
  begin
    SerRecvString(2,rstring);
    HexByteRead(rstring,ourbuffer^[index]);
  end;
  if not SerRecvChar(retchar) then SerError := true;
end;

function InquireRev : byte;
var
rstring,sstring : string;
data : byte;
retchar : char;
begin
  sstring := SerInquireRevCom +CR;
  SerSendString(sstring);
  SerRecvString(2,rstring);
  if not SerRecvChar(retchar) then SerError := true;
  HexbyteRead(rstring,data);
  InquireRev := data;
end;

procedure SerWriteEEPROM(addr: byte;data:byte);
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteEEPROMCom + HexString(addr,2)+ HexString(data,2) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

function SerReadEEPROM(add:byte) : byte;
var
rstring,sstring : string;
data : byte;
retchar : char;
begin
  sstring := SerReadEEPROMCom +HexString(add,2)+ CR;
  SerSendString(sstring);
  SerRecvString(2,rstring);
  if not SerRecvChar(retchar) then SerError := true;
  HexbyteRead(rstring,data);
  SerReadEEPROM := data;
end;

procedure SerWriteEEPROMWord(addr: word;data:word);
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteEEPROMWordCom + HexString(addr,4)+ HexString(data,4) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

function SerReadEEPROMWord(add:word) : word;
var
rstring,sstring : string;
data : word;
retchar : char;
begin
  sstring := SerReadEEPROMWordCom +HexString(add,4)+ CR;
  SerSendString(sstring);
  SerRecvString(4,rstring);
  if not SerRecvChar(retchar) then SerError := true;
  HexWordRead(rstring,data);
  SerReadEEPROMWord := data;
end;

procedure EraseGroup(block : word);
var
sstring : string;
retchar : char;
begin
  sstring := SerEraseGroupCom+ HexString(block,4)+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure WritePLL(data:byte);
var
sstring : string;
retchar : char;
begin
  sstring := SerWriteOscCom + HexString(data,2) + CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

procedure ConfigureFPGA;
var
sstring : string;
retchar : char;
begin
  sstring := SerConfigCom+CR;
  SerSendString(sstring);
  if not SerRecvChar(retchar) then SerError := true;
end;

function SerSync : boolean;
var
i : longint;
retchar : char;
sstring : string;
begin
{  forceRTSLow(TheComPort); bogus - dos only}
  SerSync := false;
  SerTossChars;
  SerSetRTSHigh;
  SerSendChar('x'); { send invalid command or data }
  SerSendChar(CR);
  if SerRecvChar(retchar) then
  begin
    delay(10); { wait for chars to arrive }
    SerTossChars;
    SerSendChar('x'); { send invalid command or data }
    SerSendChar(CR);
    if SerRecvChar(retchar) then
    begin
     delay(10); { wait for chars to arrive }
     SerTossChars;
      if retchar = '?' then
      begin
{ checking changed to avoid SerWriteProtect }
        sstring := InquireID;
        begin
          if length(sstring) = 4 then
          begin
            SerSync := true;
            SerError := false;
          end
        end;
      end;
    end;
  end;
end;

function SerialCheck : boolean;
begin
  SerialCheck := true;
  if SerError then
  begin
    SerialCheck := false;
    SerSync;
  end;
end;

{ changed group size to word 11-30-06 ge }
