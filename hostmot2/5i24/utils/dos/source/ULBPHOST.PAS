{for LBP}

const
OurRPC = 32; { out of the way half way up }
{$IFDEF FIFO}

procedure LBPInitSoftDMC(TheBasePort : word);
begin
  IFIFOPort   := TheBasePort + IFIFOPortOffset;
  QFIFOPort   := TheBasePort + QFIFOPortOffset;
  StatusPort  := TheBasePort + StatusRegOffset;
  ROMAddPort  := TheBasePort + ROMAddOffset;
  ROMDataPort := TheBasePort + ROMDataOffset;
end;

function LBPReadFIFOStatus : word;
begin
    LBPReadFIFOStatus := LBPReadWord(StatusPort);
end;
(*
procedure LBPWaitForIRBFIFONotEmpty;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((LBPReadFIFOStatus and IRE = 0) or (loop > PollTimeOut));
  if loop > PollTimeOut then Error(TimeoutIRBFIFONotEmpty);
end;

procedure LBPWaitForICDFIFONotFull;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((LBPReadFIFOStatus and IFF = 0) or (loop > PollTimeOut));
  if loop > PollTimeOut then Timeouterror(' ICD FIFO not full');
end;

procedure LBPWaitForICDFIFONotHalfFull;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((LBPReadFIFOStatus and IFH = 0)  or (loop > PollTimeOut));
  if loop > PollTimeOut then Timeouterror(' ICD FIFO not half full');
end;

procedure LBPWaitForQRBFIFONotEmpty;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((LBPReadFIFOStatus and QRE = 0)  or (loop > PollTimeOut));
  if loop > PollTimeOut then Timeouterror(' QRB data');
end;

procedure LBPWaitForQCDFIFONotFull;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((LBPReadFIFOStatus and QFF = 0)  or (loop > PollTimeOut));
  if loop > PollTimeOut then Timeouterror(' QCD FIFO not full');
end;

procedure LBPWaitForQCDFIFONotHalfFull;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((LBPReadFIFOStatus and QFH = 0)  or (loop > PollTimeOut));
  if loop > PollTimeOut then Timeouterror(' QCD FIFO not half full');
end;

procedure LBPWaitForQRBFIFOHalfFull;
var loop : longint;
begin
  loop := 0;
  repeat
    loop := loop +1;
  until ((LBPReadFIFOStatus and QRH <> 0)  or (loop > PollTimeOut));
  if loop > PollTimeOut then Timeouterror(' QRB FIFO half full');
end;
*)
procedure LBPWriteIFIFO(data: word);
begin
  LBPWriteWord(IFIFOPort,data);
end;

procedure LBPWriteQFIFO(data: word);
begin
  LBPWriteWord(QFIFOPort,data);
end;

function LBPReadIFIFO : word;
begin
  LBPReadIFIFO := LBPReadWord(IFIFOPort);
end;

function LBPReadQFIFO : word;
begin
  LBPReadQFIFO := LBPReadWord(QFIFOPort);
end;

procedure LBPWriteParamWord(command,thedata : word);
{16 bit only parameter write}
begin
  LBPWriteIFIFO(command);
  LBPWriteIFIFO(word(thedata));
end;

procedure LBPWriteCommand(command: word);
{token write}
begin
  LBPWriteIFIFO(command);
end;

procedure LBPWriteParam(command: word;thedata : longint);
{ full 32 bit parameter write - 2 words }
begin
  LBPWriteIFIFO(command);
  LBPWriteIFIFO(LongIntRec(thedata).LowWord);
  LBPWriteIFIFO(LongIntRec(thedata).HighWord);
end;

procedure LBPWriteParamDouble(command: word;thedata : comp);
{ 64 bit parameter write - 4 words }
begin
  LBPWriteIFIFO(command);
  LBPWriteIFIFO(DoubleIntRec(thedata).word0);
  LBPWriteIFIFO(DoubleIntRec(thedata).word1);
  LBPWriteIFIFO(DoubleIntRec(thedata).word2);
  LBPWriteIFIFO(DoubleIntRec(thedata).word3);
end;

procedure LBPWriteParamBlock(axis,address,length : word; thedata : ParamArray);
var idx : word;
{16 bit multiple parameter write}
begin
  { Note: this will fail horribly if length > (FIFOSize/2 -2) }
  LBPWriteIFIFO(BlockFlag or (length-1) or (axis shl AxisOffset));
  LBPWriteIFIFO(address);
  for idx := 1 to length do
  begin
    LBPWriteIFIFO(thedata[idx]);
  end;
end;

function LBPReadParamWord(command: word):word;
{ 16 bit parameter read }
var
rdata : longint;
begin
  LBPWriteIFIFO(command);
  rdata := LBPReadIFIFO;
  LBPReadParamWord :=rdata;
end;

function LBPReadParam(command: word) : longint;
{full 32 bit parameter read }
var
rdata : longint;
begin
  LBPWriteIFIFO(command);
  LongIntRec(rdata).LowWord := LBPReadIFIFO;  { read first }
{  LBPWaitForIFIFONotEmpty; }
{ theoretically this is needed but no interface currently is fast }
{ enough to read faster than the DSP can write }
  LongIntRec(rdata).HighWord :=LBPReadIFIFO;
  LBPReadParam:= rdata;
end;

{$IFDEF COPROC}
function LBPReadParamDouble(command: word) : comp;
{64 bit parameter read }
var
rdata : comp;
begin
  LBPWriteIFIFO(command);
  DoubleIntRec(rdata).word0 := LBPReadIFIFO;  { read first }
  DoubleIntRec(rdata).word1 := LBPReadIFIFO;
  DoubleIntRec(rdata).word2 := LBPReadIFIFO;
  DoubleIntRec(rdata).word3 := LBPReadIFIFO;
  LBPReadParamDouble := rdata;
end;
{$ENDIF}

procedure LBPWriteParamWordQ(command,thedata : word);
{16 bit only parameter write}
begin
  LBPWriteQFIFO(command);
  LBPWriteQFIFO(thedata);
end;

procedure LBPWriteCommandQ(command : word);
{token write}
begin
  LBPWriteQFIFO(command);
end;

procedure LBPWriteParamQ(command: word;thedata : longint);
{ full 32 bit parameter write - 2 words }
begin
  LBPWriteQFIFO(command);
  LBPWriteQFIFO(word(thedata));
  LBPWriteQFIFO(word(thedata shr 16));
end;

procedure LBPWriteParamDoubleQ(command: word;thedata : comp);
{ 64 bit parameter write - 4 words }
begin
  LBPWriteQFIFO(command);
  LBPWriteQFIFO(DoubleIntRec(thedata).word0);
  LBPWriteQFIFO(DoubleIntRec(thedata).word1);
  LBPWriteQFIFO(DoubleIntRec(thedata).word2);
  LBPWriteQFIFO(DoubleIntRec(thedata).word3);
end;

function LBPReadParamWordQ(command: word):word;
{ 16 bit parameter read }
var
rdata : longint;
begin
  LBPWriteQFIFO(command);
  rdata := LBPReadQFIFO;
  LBPReadParamWordQ :=rdata;
end;

function LBPReadParamQ(command: word) : longint;
{full 32 bit parameter read }
var
rdata : longint;
firstword : word;
begin
  LBPWriteQFIFO(command);
  firstword := LBPReadQFIFO;  { read first }
{  LBPWaitForQFIFONotEmpty; }
{ theoretically this is needed but no interface currently is fast }
{ enough to read faster than the DSP can write }
  rdata := (LBPReadQFIFO) *65536 + firstword;
  LBPReadParamQ:= rdata;
end;

{$IFDEF COPROC}
function LBPReadParamDoubleQ(command: word) : comp;
{64 bit parameter read }
var
rdata : comp;
begin
  LBPWriteQFIFO(command);
  DoubleIntRec(rdata).word0 := LBPReadQFIFO;  { read first }
  DoubleIntRec(rdata).word1 := LBPReadQFIFO;
  DoubleIntRec(rdata).word2 := LBPReadQFIFO;
  DoubleIntRec(rdata).word3 := LBPReadQFIFO;
  LBPReadParamDoubleQ:= rdata;
end;
{$ENDIF}

procedure LBPReadQFIFO64N(n : word;bufptr : LBPDataBuffPtr);
var
data : word;
index : word;
oloop,iloop : word;
begin
  index := 0;
  for oloop := 1 to n do
  begin
    SerSendChar(char(LBPRPC_byte or OurRPC));
    for iloop := 0 to 63 do
    begin
      SerRecvChar(char(WordByteRec(data).Byte0));
      SerRecvChar(char(WordByteRec(data).Byte1));
      bufptr^[index] := data;
      index := index + 1;
    end;
  end;
end;

{$IFDEF WINDOWS}
procedure LBPSetupReadQFIFO64N;
var
index : byte;
rpctarget : word;

begin
  rpctarget := OurRPC * LBPReadRPCPitch;
  {This routine builds up a RPC to read 64 words from the QFIFO at OurRPC}

  XmitBufferIndex :=1;
  AddByteToXmitBuffer(LBPWRITE_byte or LBPRPCMEM_flag);
  AddByteToXmitBuffer(LBPTRUE_flag);   { enable RPC memory access }

  AddByteToXmitBuffer(LBPCOMMAND_byte or LBPWRITE_byte or LBPA2_byte or LBPINC_byte or LBPD4_byte);
  AddByteToXmitBuffer(WordRec(rpctarget).lowbyte);
  AddByteToXmitBuffer(WordRec(rpctarget).highbyte);
  AddByteToXmitBuffer(LBPCOMMAND_byte or LBPA2_byte or LBPD2_byte);
  AddByteToXmitBuffer(WordRec(QFIFOPort).lowbyte);
  AddByteToXmitBuffer(WordRec(QFIFOPort).highbyte);
  AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte); {2 read commands in RPC buffer}

  for index := 1 to 7 do
  begin
    AddByteToXmitBuffer(LBPCOMMAND_byte or LBPWRITE_byte or LBPINC_byte or LBPD8_byte);
    AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte);
    AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte);
    AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte);
    AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte);
    AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte);
    AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte);
    AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte);
    AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte); { 58 }
  end;

  AddByteToXmitBuffer(LBPCOMMAND_byte or LBPWRITE_byte or LBPINC_byte or LBPD4_byte);
  AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte);
  AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte);
  AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte);
  AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte); {62}

  AddByteToXmitBuffer(LBPCOMMAND_byte or LBPWRITE_byte or LBPINC_byte or LBPD2_byte);
  AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte);
  AddByteToXmitBuffer(LBPCOMMAND_byte or LBPD2_byte); {64}

  AddByteToXmitBuffer(LBPCOMMAND_byte or LBPWRITE_byte);
  AddByteToXmitBuffer(LBPRPCEND_byte);

  AddByteToXmitBuffer(LBPWRITE_byte or LBPRPCMEM_flag);
  AddByteToXmitBuffer(LBPFALSE_flag);   { disable RPC memory access }

  ser.SendBuffer(@XmitBuffer,XmitBufferIndex-1);
  ser.Flush;
end;

{$ELSE}
procedure LBPSetupReadQFIFO64N;
var
rpctarget : word;
index : integer;
  {This routine builds up a RPC to read 64 words from the QFIFO at OurRPC}
begin
  rpctarget := OurRPC * LBPReadRPCPitch;

  SerSendChar(char(LBPWRITE_byte or LBPRPCMEM_flag));
  SerSendChar(char(LBPTRUE_flag));   { enable RPC memory access }

  SerSendChar(char(LBPCOMMAND_byte or LBPWRITE_byte or LBPA2_byte or LBPINC_byte or LBPD4_byte));
  SerSendChar(char(WordRec(rpctarget).lowbyte));
  SerSendChar(char(WordRec(rpctarget).highbyte));
  SerSendChar(char(LBPCOMMAND_byte or LBPA2_byte or LBPD2_byte));
  SerSendChar(char(WordRec(QFIFOPort).lowbyte));
  SerSendChar(char(WordRec(QFIFOPort).highbyte));
  SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte)); {2 read commands in RPC buffer}

  for index := 1 to 7 do
  begin
    SerSendChar(char(LBPCOMMAND_byte or LBPWRITE_byte or LBPINC_byte or LBPD8_byte));
    SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte));
    SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte));
    SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte));
    SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte));
    SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte));
    SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte));
    SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte));
    SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte)); { 58 }
  end;

  SerSendChar(char(LBPCOMMAND_byte or LBPWRITE_byte or LBPINC_byte or LBPD4_byte));
  SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte));
  SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte));
  SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte));
  SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte)); {62}

  SerSendChar(char(LBPCOMMAND_byte or LBPWRITE_byte or LBPINC_byte or LBPD2_byte));
  SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte));
  SerSendChar(char(LBPCOMMAND_byte or LBPD2_byte)); {64}

  SerSendChar(char(LBPCOMMAND_byte or LBPWRITE_byte));
  SerSendChar(char(LBPRPCEND_byte));
  SerSendChar(char(LBPWRITE_byte or LBPRPCMEM_flag));
  SerSendChar(char(LBPFALSE_flag));   { disable RPC memory access }
end;

{$ENDIF}

{$ENDIF FIFO}

