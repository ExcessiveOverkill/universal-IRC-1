{for LBP}

{I LBP.pas}
{$I CRC8.pas}


const
XmitBufferSize = 1024;
NullCRC = char(0);

type
LBPDataBuffertype = array[0..4095] of word;
LBPDataBuffPtr = ^LBPDataBuffertype;

var
LBPDataBuffer : LBPDataBuffertype;
XmitBuffer : array[1 .. XmitBufferSize] of byte;
XmitBufferIndex : integer;
ExitOnCRCError : boolean;
LBPCRCEnabled : boolean;
LBPCRCError : boolean;
LBPCRC : byte;
rb : byte;
type
WordByteRec = record
  Byte0  : byte;
  Byte1  : byte;
end;

CompByteRec = record
  Byte0  : byte;
  Byte1  : byte;
  Byte2  : byte;
  Byte3  : byte;
  Byte4  : byte;
  Byte5  : byte;
  Byte6  : byte;
  Byte7  : byte;
end;

procedure AppendCRC(var s : string);
var i : integer;
thebyte,lookupbyte : byte;
begin
  if LBPCRCEnabled then
  begin
    LBPCRC := 0;
    for i := 1 to length(s) do
    begin
      thebyte := byte(s[i]);
      lookupbyte := LBPCRC xor thebyte;
      LBPCRC := GetCRC8(lookupbyte);
    end;
    s := s + char(LBPCRC);
{$IFDEF CRCDEBUG}
    write('Appended ');
    hexprint(LBPCRC,2);
    Writeln
{$ENDIF CRCDEBUG}
  end;
end;

function CheckCRC(is : string) : boolean;
var i : integer;
thebyte,lookupbyte : byte;
tout : boolean;
begin
  LBPCRCError := false;
  if LBPCRCEnabled then
  begin
    LBPCRC := 0;
    for i := 1 to length(is) do
    begin
      thebyte := byte(is[i]);
      lookupbyte := LBPCRC xor thebyte;
      LBPCRC := GetCRC8(lookupbyte);
    end;
    tout := not SerRecvChar(char(thebyte));
    if (tout and ExitOnCRCError) then Bumout('Serial Timeout Error Waiting for CRC!');
    CheckCRC := (theByte = LBPCRC);
{$IFDEF CRCDEBUG}
      write(' Got CRC  ');
      HexPrint(thebyte,2);
      write(' CRC should be  ');
      HexPrint(LBPCRC,2);
      writeln;
{$ENDIF CRCDEBUG}
    if theByte <> LBPCRC then
    begin
      LBPCRCError := true;
      if ExitOnCRCError then Bumout('CRC Error!');
    end;
  end;
end;

procedure AddByteToXmitBuffer(d: byte);
begin
  XmitBuffer[XmitBufferIndex] := d;
  XmitBufferIndex := XmitBufferIndex + 1;
end;

function LBPReadByte(add : word) : byte;
var s, is : string;
begin
  s := char(LBPCOMMAND_byte or LBPA2_byte or LBPD1_byte);
  s := s + char(WordByteRec(add).Byte0);
  s := s + char(WordByteRec(add).Byte1);
  AppendCRC(s);
  SerSendString(s);
  SerError := not SerRecvString(1,is);
  LBPCRCError := CheckCRC(is);
  LBPReadByte := byte(is[1]);
end;

function LBPReadWord(add : word) : word;
var
s, is : string;
data : word;
begin
  s := char(LBPCOMMAND_byte or LBPA2_byte or LBPD2_byte);
  s := s + char(WordByteRec(add).Byte0);
  s := s + char(WordByteRec(add).Byte1);
  AppendCRC(s);
  SerSendString(s);
  if not SerRecvString(2,is) then
  begin
    if ExitOnTimeout then Error(CharTimeoutErr);
  end;
  WordByteRec(data).Byte0 := byte(is[1]);
  WordByteRec(data).Byte1 := byte(is[2]);
  LBPCRCError := CheckCRC(is);
  LBPReadWord := data;
end;

function LBPReadLong(add : word) : longint;
var data : longint;
s, is : string;
tout : boolean;
begin
  s := char(LBPCOMMAND_byte or LBPA2_byte or LBPD4_byte);
  s := s + char(WordByteRec(add).Byte0);
  s := s + char(WordByteRec(add).Byte1);
  AppendCRC(s);
  SerSendString(s);
  {SerError := not SerRecvString(4,is);}
  tout := not SerRecvString(4,is);
  SerError := SerError or tout;
  if tout then Bumout('Serial Timeout Error Waiting for Long!');
  LongIntByteRec(data).Byte0 := byte(is[1]);
  LongIntByteRec(data).Byte1 := byte(is[2]);
  LongIntByteRec(data).Byte2 := byte(is[3]);
  LongIntByteRec(data).Byte3 := byte(is[4]);
  LBPCRCError := CheckCRC(is);
  LBPReadLong := data;
end;

function LBPReadDouble(add : word) : comp;
var data : comp;
s, is : string;
tout : boolean;
begin
  s := char(LBPCOMMAND_byte or LBPA2_byte or LBPD8_byte);
  s := s + char(WordByteRec(add).Byte0);
  s := s + char(WordByteRec(add).Byte1);
  AppendCRC(s);
  SerSendString(s);
  tout := not SerRecvString(8,is);
  if tout then Bumout('Serial Timeout Error Waiting Double!');

  CompByteRec(data).Byte0 := byte(is[1]);
  CompByteRec(data).Byte1 := byte(is[2]);
  CompByteRec(data).Byte2 := byte(is[3]);
  CompByteRec(data).Byte3 := byte(is[4]);
  CompByteRec(data).Byte4 := byte(is[5]);
  CompByteRec(data).Byte5 := byte(is[6]);
  CompByteRec(data).Byte6 := byte(is[7]);
  CompByteRec(data).Byte7 := byte(is[8]);
  LBPCRCError := CheckCRC(is);
  LBPReadDouble := data;
end;

procedure LBPWriteByte(add:word; data: byte);
var s : string;
begin
  s := char(LBPCOMMAND_byte or LBPWRITE_byte or LBPA2_byte or LBPD1_byte);
  s := s + char(WordByteRec(add).Byte0);
  s := s + char(WordByteRec(add).Byte1);
  s := s + char(data);
  AppendCRC(s);
  SerSendString(s);
  CheckCRC(NullCRC);
end;

procedure LBPWriteWord(add:word; data: word);
var s : string;
begin
  s := char(LBPCOMMAND_byte or LBPWRITE_byte or LBPA2_byte or LBPD2_byte);
  s := s + char(WordByteRec(add).Byte0);
  s := s + char(WordByteRec(add).Byte1);
  s := s + char(WordByteRec(data).Byte0);
  s := s + char(WordByteRec(data).Byte1);
  AppendCRC(s);
  SerSendString(s);
  CheckCRC(NullCRC);
end;

procedure LBPWriteLong(add:word; data: longint);
var s : string;
begin
  s := char(LBPCOMMAND_byte or LBPWRITE_byte or LBPA2_byte or LBPD4_byte);
  s := s + char(WordByteRec(add).Byte0);
  s := s + char(WordByteRec(add).Byte1);
  s := s + char(LongIntByteRec(data).Byte0);
  s := s + char(LongIntByteRec(data).Byte1);
  s := s + char(LongIntByteRec(data).Byte2);
  s := s + char(LongIntByteRec(data).Byte3);
  AppendCRC(s);
  SerSendString(s);
  CheckCRC(NullCRC);
end;

procedure LBPWriteDouble(add:word; data: comp);
var s : string;
begin
  s := char(LBPCOMMAND_byte or LBPWRITE_byte or LBPA2_byte or LBPD8_byte);
  s := s + char(WordByteRec(add).Byte0);
  s := s + char(WordByteRec(add).Byte1);
  s := s + char(CompByteRec(data).Byte0);
  s := s + char(CompByteRec(data).Byte1);
  s := s + char(CompByteRec(data).Byte2);
  s := s + char(CompByteRec(data).Byte3);
  s := s + char(CompByteRec(data).Byte4);
  s := s + char(CompByteRec(data).Byte5);
  s := s + char(CompByteRec(data).Byte6);
  s := s + char(CompByteRec(data).Byte7);
  AppendCRC(s);
  SerSendString(s);
  CheckCRC(NullCRC);
end;

function LBPLocalRead(command : byte) : byte;
var s,is : string;
begin
  s := char(command);
  AppendCRC(s);
  SerSendString(s);
  SerError := not SerRecvString(1,is);
  LBPCRCError := CheckCRC(is);
  LBPLocalRead := byte(is[1]);
end;

procedure LBPLocalWrite(command,data : byte);
var s : string;
begin
  s := char(LBPWRITE_byte or command);
  s := s + char(data);
  AppendCRC(s);
  SerSendString(s);
  CheckCRC(NullCRC);
end;

function LBPReadCookie: byte;
begin
  LBPReadCookie := LBPLocalRead(LBPREADCOOKIE_byte);
end;

function LBPReadRPCPitch: byte;
begin
  LBPReadRPCPitch := LBPLocalRead(LBPRPCPITCH_byte);
end;

function LBPReadCardName : string;
var
s : string;
begin
  s := '';
  s := s + char(LBPLocalRead(LBPCARDNAME0_byte));
  s := s + char(LBPLocalRead(LBPCARDNAME1_byte));
  s := s + char(LBPLocalRead(LBPCARDNAME2_byte));
  s := s + char(LBPLocalRead(LBPCARDNAME3_byte));
  LBPReadCardName := s;
end;

function LBPReadUnitNumber : longint;
var data : longint;
s, is : string;
tout : boolean;
begin
  s := char($BC);
  AppendCRC(s);
  SerSendString(s);

  tout := not SerRecvString(4,is);
  SerError := SerError or tout;
  if tout then Bumout('Serial Timeout Error Waiting for Long!');
  LongIntByteRec(data).Byte0 := byte(is[1]);
  LongIntByteRec(data).Byte1 := byte(is[2]);
  LongIntByteRec(data).Byte2 := byte(is[3]);
  LongIntByteRec(data).Byte3 := byte(is[4]);
  LBPCRCError := CheckCRC(is);
  LBPReadUnitNumber := data;
end;

function LBPDiscover : longint;
var data : longint;
s, is : string;
tout : boolean;
begin
  s := char($BB);
  AppendCRC(s);
  SerSendString(s);
  tout := not SerRecvString(6,is);
  SerError := SerError or tout;
  if tout then Bumout('Serial Timeout Error Waiting for Long!');
  { skip wsize and rsize }
  LongIntByteRec(data).Byte0 := byte(is[3]);
  LongIntByteRec(data).Byte1 := byte(is[4]);
  LongIntByteRec(data).Byte2 := byte(is[5]);
  LongIntByteRec(data).Byte3 := byte(is[6]);
  LBPCRCError := CheckCRC(is);
  LBPDiscover := data;
end;

procedure LBPEnableCRC;
begin { do manually because crcs are enabled after command }
  SerSendChar(char(LBPWRITE_byte or LBPENACRC_FLAG));
  SerSendChar(char(LBPTRUE_flag));
  LBPCRCEnabled := true;
  CheckCRC(NullCRC);
end;

procedure LBPDisableCRC;
begin
  LBPLocalWrite(LBPENACRC_flag,LBPFALSE_flag);
end;

function LBPReadVersion : byte;
begin
  LBPReadVersion := LBPLocalRead(LBPVERSION_byte);
end;

function LBPReadStatus: byte;
begin
  LBPReadStatus := LBPLocalRead(LBPSTATUS_byte);
end;

procedure LBPWriteStatus(data : byte);
begin
  LBPLocalWrite(LBPSTATUS_byte,data);
end;

procedure LBPClearStatus;
begin
  LBPLocalWrite(LBPSTATUS_byte,0);
end;

function LBPReadRPCSize : word;
var data : word;
begin
  WordByteRec(data).Byte0 := LBPLocalRead(LBPRPCSIZEL_byte);
  WordByteRec(data).Byte1 := LBPLocalRead(LBPRPCSIZEH_byte);
  LBPReadRPCSize := data;
end;

procedure LBPWriteLEDS(data : byte);
begin
  LBPLocalWrite(LBPSETLEDS_byte,data);
end;

procedure LBPWriteAddToAddress(n : byte);
begin
  LBPLocalWrite(LBPADDADDRESS_byte,n);
end;

procedure LBPProcReset;
begin
  LBPLocalWrite(LBPPROCRESET_byte,LBPRESETCODE_byte);
end;

procedure LBPSoftDMCResetOn;
begin
  LBPWriteWord(ROMAddPort,$8000); { Reset on }
end;

procedure LBPSoftDMCResetOff;
begin
  LBPWriteWord(ROMAddPort,$0000); { Reset Off }
end;

procedure LBPWriteRom(add : word;data : word);
begin
  LBPWriteWord(ROMAddPort,(add or ProcResetBit));
  LBPWriteWord(ROMDataPort,data);
end;

function LBPReadRom(add : word): word;
begin
  LBPWriteWord(ROMAddPort,(add or ProcResetBit));
  LBPReadRom := LBPReadWord(ROMDataPort);
end;


procedure LBPFlashStart;
begin
  LBPLocalWrite(LBPNONVOL_flag,LBPNONVOLFLASH_byte);
end;

procedure LBPFlashStop;
begin
  LBPLocalWrite(LBPNONVOL_flag,0);
end;

function LBPGetWriteSize : word;
begin
  LBPGetWriteSize := 1 shl LBPReadByte(LBPFLASHWRITESIZE_ptr);
end;

function LBPGetEraseSize : word;
begin
  LBPGetEraseSize := 1 shl LBPReadByte(LBPFLASHERASESIZE_ptr);
end;

procedure LBPSetOffset(off : longint);
begin
  LBPWriteLong(LBPFLASHOFFSET_ptr,off);
end;

function LBPGetOffset:  longint;
begin
  LBPGetOffset := LBPReadLong(LBPFLASHOFFSET_ptr);
end;

function LBPProgSync: boolean;
var ok : boolean;
cookie : byte;
begin
  cookie := $FF;
  ok := false;
  cookie := LBPReadCookie;
  ok := (not SerError) and (cookie = LBPCOOKIECODE_byte);
  LBPProgSync := ok;
end;

procedure LBPCommitErase;
begin
  LBPWriteByte(LBPFLASHCOMMIT_ptr,LBPFLASHERASE_byte);
  if not LBPProgSync then BumOut('Sync error');
end;

procedure LBPCommitWrite;
begin
  LBPWriteByte(LBPFLASHCOMMIT_ptr,LBPFLASHWRITE_byte);
  if not LBPProgSync then BumOut('Sync error');
end;

procedure LBPWriteEEPROM(add : word;data : byte);
begin
  LBPLocalWrite(LBPNONVOL_flag,LBPNONVOLEEPROM_byte);
  LBPWriteByte(add,data);
  if not LBPProgSync then BumOut('EEPROM Byte Write Sync error');
  LBPLocalWrite(LBPNONVOL_flag,0);
end;

function LBPReadEEPROM(add : word): byte;
begin
  LBPLocalWrite(LBPNONVOL_flag,LBPNONVOLEEPROM_byte);
  LBPReadEEPROM := LBPReadByte(add);
  LBPLocalWrite(LBPNONVOL_flag,0);
end;

procedure LBPWriteEEPROMWord(add : word;data : word);
begin
  LBPLocalWrite(LBPNONVOL_flag,LBPNONVOLEEPROM_byte);
  LBPWriteWord(add,data);
  if not LBPProgSync then BumOut('EEPROM Word Write Sync error');
  LBPLocalWrite(LBPNONVOL_flag,0);
end;

function LBPReadEEPROMWord(add : word): word;
begin
  LBPLocalWrite(LBPNONVOL_flag,LBPNONVOLEEPROM_byte);
  LBPReadEEPROMWord := LBPReadWord(add);
  LBPLocalWrite(LBPNONVOL_flag,0);
end;

procedure LBPWriteEEPROMLong(add : word;data : longint);
begin
  LBPLocalWrite(LBPNONVOL_flag,LBPNONVOLEEPROM_byte);
  LBPWriteLong(add,data);
  if not LBPProgSync then BumOut('EEPROM Long Write Sync error');
  LBPLocalWrite(LBPNONVOL_flag,0);
end;

function LBPReadEEPROMLong(add : word): longint;
begin
  LBPLocalWrite(LBPNONVOL_flag,LBPNONVOLEEPROM_byte);
  LBPReadEEPROMLong := LBPReadLong(add);
  LBPLocalWrite(LBPNONVOL_flag,0);
end;

(*
procedure LBPWriteBlock(add:word; ourbuffer : BBufPtrType);
var s : string;
i : integer;
begin
  s := '';
  s := s + char(LBPCOMMAND_byte or LBPWRITE_byte or LBPA2_byte or LBPD8_byte);
  s := s + char(WordByteRec(add).Byte0);
  s := s + char(WordByteRec(add).Byte1);
  s := s + char(ourbuffer^[0]);
  s := s + char(ourbuffer^[1]);
  s := s + char(ourbuffer^[2]);
  s := s + char(ourbuffer^[3]);
  s := s + char(ourbuffer^[4]);
  s := s + char(ourbuffer^[5]);
  s := s + char(ourbuffer^[6]);
  s := s + char(ourbuffer^[7]);
  AppendCRC(s);
  SerSendString(s);
  CheckCRC(NullCRC);
end;

procedure LBPReadBlock(add:word; ourbuffer : RBufPtrType);
var data : comp;
begin
  data := LBPReadDouble(add);
  ourbuffer^[0] := CompByteRec(data).Byte0;
  ourbuffer^[1] := CompByteRec(data).Byte1;
  ourbuffer^[2] := CompByteRec(data).Byte2;
  ourbuffer^[3] := CompByteRec(data).Byte3;
  ourbuffer^[4] := CompByteRec(data).Byte4;
  ourbuffer^[5] := CompByteRec(data).Byte5;
  ourbuffer^[6] := CompByteRec(data).Byte6;
  ourbuffer^[7] := CompByteRec(data).Byte7;
end;
*)
function LBPSync(var message : string) : boolean;
var origchartimeout : longint;
begin
  SerError := false;
  ExitOnTimeout := false;
  ExitOnCRCError := false;
  LBPSync := false;
  LBPCRCEnabled := false;
  LBPCRC := 0;
  message := 'LBP Serial Communication failed !';
  SerTossChars;
  delay(MaxParserTimeout); { worst case resync timeout delay }
  SerTossChars;
  origchartimeout := CharTimeout;
  CharTimeout := CharTimeout div 20;
  if LBPProgSync then
  begin
    LBPSync := true;
    message := 'Using LBP Serial Interface';
  end
  else
  begin { try with crcs enabled }
    SerTossChars;
    delay(MaxParserTimeout); { worst case resync timeout delay }
    SerTossChars;
    SerError := false;
{$IFDEF DEBUG}
    writeln('Trying with CRC''s');
{$ENDIF DEBUG}
    LBPCRCEnabled := true;
    if LBPProgSync then
    begin
      LBPClearStatus;
      LBPSync := true;
      message := 'Using LBP Serial Interface With CRCs';
    end
    else
    begin
      LBPCRCEnabled := false;
    end;
  end;
  CharTimeout := origchartimeout;
  ExitOnTimeout := true;
  ExitOnCRCError := true;
end;

{ fixed eeprom write with progsync }
