{ mesa fpga UART 32 BIT }
{I HM2LOW}

const
MesaUARTBaseAdd  = $6000;

{ registers }
MesaUARTRxTxStride   = $10;
MesaUARTRegStride    = $04;

MesaUARTTxData1      = $00; { 1 byte push }
MesaUARTTxData2      = $04; { 2 byte push }
MesaUARTTxData3      = $08; { 3 byte push }
MesaUARTTxData4      = $0C; { 4 byte push }

MesaUARTRxData1      = $400; { 1 byte pop }
MesaUARTRxData2      = $404; { 2 byte pop }
MesaUARTRxData3      = $408; { 3 byte pop }
MesaUARTRxData4      = $40C; { 4 byte pop }

MesaUARTTxFIFOCount  = $100;
MesaUARTTxMode       = $300;

MesaUARTRxFIFOCount  = $500;
MesaUARTRxMode       = $700;

{ setup mode register map }
MesaUARTTxBitRate    = $200;
MesaUARTRxBitRate    = $600;
MesaUARTBitRateMask= $FFFFF; { 20 bits }

MesaUARTRxFIFOSize   = 16; { bytes }
MesaUARTTxFIFOSize   = 16; { slots }
MesaUARTNumUARTs     = 8;
MesaUARTFIFOMask     = $1F;

{ bits }
MesaUARTTxFIFOError        = $0010; { fifo push overflow }
MesaUARTTxDriveEnableAuto  = $0020;
MesaUARTDriveEnableBit     = $0040;

MesaUARTRxFalseStartBit    = $0001;
MesaUARTRxOverRun          = $0002;
MesaUARTRxMaskEnableBit    = $0004;
MesaUARTRxFIFOError        = $0010; { read more than there }
MesaUARTRxLostData         = $0020;
MesaUARTRxMask             = $0040;
MesaUARTRxFIFOHasData      = $0080;

var
MesaUARTClock : longint;

function BrAccumval(br,bm : real) : longint;
var  baud : real;
begin
  baud := ((br*1048576.0)/MesaUARTClock)/bm;
  {writeln('MesaUARTClock ',MesaUARTClock);
  writeln('Braccum ',baud:10:3);}
  BrAccumval := trunc(baud);
end;

function RxCharsAvailable : integer;
var ouraddress : word;
begin
  ouraddress :=TheComport*MesaUartRegStride+MesaUARTBaseAdd+MesaUARTRxFIFOCount;
  RxCharsAvailable := Read32(ouraddress) and MesaUARTFIFOMask;
end;

function TxSlotsAvailable : integer;
var ouraddress : word;
begin
  ouraddress := TheComport*MesaUartRegStride+MesaUARTBaseAdd+MesaUARTTxFIFOCount;
  TxSlotsAvailable := MesaUARTTxFIFOSize - (Read32(ouraddress) and MesaUARTFIFOMask);
end;

procedure MesaSerTossChars(comport : word);
begin
  Write32(comport*MesaUartRegStride+MesaUARTBaseAdd+MesaUARTRxFifoCount,0);
end;

procedure MesaUARTSetBitrate(comPort : word; bitrate : longint);
begin
  Write32((comport*MesaUartRegStride)+MesaUARTBaseAdd+MesaUARTTxBitRate,bitrate);
  Write32((comport*MesaUartRegStride)+MesaUARTBaseAdd+MesaUARTRxBitRate,bitrate);
end;

procedure MesaUARTGetBitrate(comport : word; var bitrate : longint);
begin
  bitrate := MesaUartBitrateMask and Read32((comport*MesaUartRegStride)+MesaUARTBaseAdd+MesaUARTTxBitRate);
end;

procedure MesaUARTSetBaud(comport : word;br,bm : real);
begin
  MesaUARTSetBitrate(comport,BrAccumval(br,bm));
end;

function MesaBaudRateValid(br,bm : real) : boolean;
var ourbaud,testbaud,ratio : real;
value : real;
begin
  MesaBaudRateValid := true;
  ourbaud := br / bm;
  value := BrAccumval(br,bm);
  testbaud := MesaUARTClock * value / 65536.0;
  ratio := ourbaud / testbaud;
  if (ratio > 1.0) and (ratio > 1.03) then MesaBaudRateValid := false;
  if (ratio < 1.0) and (ratio < 0.97) then MesaBaudRateValid := false;
end;

function MesaSerRecvChar(var c : char) : boolean;
var timeout : longint;
ouraddress : word;
begin
  timeout := CharTimeout;
  while  ((RxCharsAvailable = 0) and (timeout<>0)) do timeout:=timeout-1;
  if timeout <> 0 then
  begin
    ouraddress := TheComport*MesaUartRxTxStride+MesaUARTBaseAdd+MesaUARTRxData1;
    c := char(Read32(ouraddress));
    MesaSerRecvChar := true;
  end
  else MesaSerRecvChar := false;
end;

function MesaSerRecvString(n : integer;var s : string) : boolean;
var
count : integer;
is : string;
timeout : longint;
begin
  timeout := CharTimeout;
  MesaSerRecvString := false;
  is := '';
  while ((RxCharsAvailable < n)  and (timeout<>0))  do timeout:=timeout-1;
  if timeout <> 0 then
  begin
    for count := 1 to n do
    begin
      is := is + char(Read32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTRxData1));
    end;
    MesaSerRecvString := true;
  end
  else for count := 1 to n do is := is + 'E';
  s := is;
end;

procedure MesaSerSendChar(c : char);
begin
  while MesaUARTTxFIFOSize = Read32((TheComport*MesaUartRegStride)+MesaUARTBaseAdd+MesaUARTTxFIFOCount) do;
  Write32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTTxData1,word(byte(c)));
end;

procedure MesaSnailSerSendChar(c : char);
begin
  Write32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTTxData1,word(byte(c)));
end;

procedure MesaSnailSendString(s : string);
var index : byte;
begin
  DisableInterrupts;
  for index := 1 to length(s) do
  begin
    MesaSnailSerSendChar(s[index]);
  end;
  EnableInterrupts;
end;

procedure FastMesaSendString(s : string);
var len,index,lindex : integer;
data : longint;
longs,remains,rem : integer;
begin
  DisableInterrupts;
  len := length(s);
  longs := len div 4;
  remains := len mod 4;
  index := 1;
  if remains <> 0 then rem := 1 else rem := 0;
  while TxSlotsAvailable < longs+rem do;
  for lindex := 1 to longs do
  begin
    LongIntByteRec(data).Byte0 := byte(s[index+0]);
    LongIntByteRec(data).Byte1 := byte(s[index+1]);
    LongIntByteRec(data).Byte2 := byte(s[index+2]);
    LongIntByteRec(data).Byte3 := byte(s[index+3]);
    index := index + 4;
    Write32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTTxData4,data);
  end;
  case remains of
    3 :
      begin
        LongIntByteRec(data).Byte0 := byte(s[index+0]);
        LongIntByteRec(data).Byte1 := byte(s[index+1]);
        LongIntByteRec(data).Byte2 := byte(s[index+2]);
        Write32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTTxData3,data);
      end;
    2 :
      begin
        LongIntByteRec(data).Byte0 := byte(s[index+0]);
        LongIntByteRec(data).Byte1 := byte(s[index+1]);
        Write32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTTxData2,data);
      end;
    1 :
      begin
        LongIntByteRec(data).Byte0 := byte(s[index+0]);
        Write32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTTxData1,data);
      end;
  end;
  EnableInterrupts;
end;

procedure SlowMesaSendString(s : string);
var len,index,lindex : integer;
data : longint;
longs,remains : integer;
begin
  DisableInterrupts;
  len := length(s);
  longs := len div 4;
  remains := len mod 4;
  index := 1;
  for lindex := 1 to longs do
  begin
    while TxSlotsAvailable = 0 do;
    LongIntByteRec(data).Byte0 := byte(s[index+0]);
    LongIntByteRec(data).Byte1 := byte(s[index+1]);
    LongIntByteRec(data).Byte2 := byte(s[index+2]);
    LongIntByteRec(data).Byte3 := byte(s[index+3]);
    index := index + 4;
    Write32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTTxData4,data);
  end;
  while TxSlotsAvailable = 0 do;
  case remains of
    3 :
      begin
        LongIntByteRec(data).Byte0 := byte(s[index+0]);
        LongIntByteRec(data).Byte1 := byte(s[index+1]);
        LongIntByteRec(data).Byte2 := byte(s[index+2]);
        Write32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTTxData3,data);
      end;
    2 :
      begin
        LongIntByteRec(data).Byte0 := byte(s[index+0]);
        LongIntByteRec(data).Byte1 := byte(s[index+1]);
        Write32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTTxData2,data);
      end;
    1 :
      begin
        LongIntByteRec(data).Byte0 := byte(s[index+0]);
        Write32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTTxData1,data);
      end;
  end;
  EnableInterrupts;
end;

procedure MesaSendString(s : string);
begin
  if length(s) > 64 then SlowMesaSendString(s) else FastMesaSendString(s);
end;

procedure oldMesaSendString(s : string);
var len,i : integer;
slots : word;
data : word;
begin
  DisableInterrupts;
  len := length(s);
  i := 1;
  while i < (len+1) do
  begin
    slots := TXSlotsAvailable;
    while (slots <> 0) and (i < (len+1)) do
    begin
      if len-i > 0 then
      begin
        WordRec(data).LowByte := byte(s[i]);
        i := i + 1;
        WordRec(data).HighByte := byte(s[i]);
        i := i + 1;
        Write32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTTxData2,word(data));
        slots := slots-1;
      end
      else
      begin
        WordRec(data).LowByte := byte(s[i]);
        i := i + 1;
        Write32((TheComport*MesaUartRxTxStride)+MesaUARTBaseAdd+MesaUARTTxData1,data);
        slots := slots-1;
      end;
    end;
  end;
  EnableInterrupts;
end;

function MesaComportThere(comport : word) : boolean;
var data : longint;
ok : boolean;
index : word;
begin
  ok := false;
  FillHM2Array;
  MesaUARTClock := Read32(HostMotClockLowOffset);
  ZeroMasks;
  MakeOutputMasks(UARTTXTag,comport);
  for index := 0 to MaxConns -1 do
  begin
    if OutputMasks[index] <> 0 then
    begin
      Write32($1100+index*4,OutputMasks[index]); { ddr }
      Write32($1200+index*4,OutputMasks[index]); { altsource }
      ok := true
    end;
  end;
  MesaComPortThere := ok;
  { check for uart present }
end;

procedure MesaSerOpen(TheComport : word; br,bm : real);
  begin
    Write32((TheComport*MesaUartRegStride)+MesaUARTBaseAdd+MesaUARTTxMode,MesaUARTDriveEnableBit + $0); { no delay }
    Write32((TheComport*MesaUartRegStride)+MesaUARTBaseAdd+MesaUARTTxFIFOCount,0); { clear Tx FIFO}
    MesaSerTossChars(TheComport); { make real sure there are no pending chars }
    MesaUARTSetBaud(TheComport,br,bm);

    Write32((TheComport*MesaUartRegStride)+MesaUARTBaseAdd+MesaUARTRxMode,$0000); { full duplex }
end;

function MesaCanRead(ms : integer) : boolean;
var ctimeout : longint;
begin
  if ms <> 0 then
  begin
    ctimeout := LoopsPermS * longint(ms);
    while ((RxCharsAvailable = 0) and (ctimeout <> 0)) do ctimeout := ctimeout -1;
    if ctimeout <> 0 then MesaCanRead := true else MesaCanRead := false;
  end
  else if (RxCharsAvailable <> 0) then MesaCanRead := true else MesaCanRead := false
end;

