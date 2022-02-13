program nmflash;

{$IFDEF WINDOWS}
uses synaser,synautil,synaip,blcksock,dos,crt;
var
ser:TBlockSerial;
TheComPort : string;
IPAddr : string;
Socket : TUDPBlockSocket;
{$ELSE}
uses dos,crt;
var TheComPort : word;
{$ENDIF}

{$I SELECTC}
{$I SELECTIO}
{I SELECTP}
{$I SELECTPR}
{$I INTERFCE}

const
DataStride = 4; {bytes}

procedure Error(err : integer);
begin
  writeln(errorrecord[err].errstr);
  halt(2);
end;

procedure Barfout(es:string);
begin
  writeln;
  writeln(es);
  halt(2);
end;

type
configfile = file;

const

FileBufferSize = 8192;
PageSize = 256;
SPICSPort = $70;
SPISregPort = $74;
DAVMask = $04;
FallbackSA = $10000;    { fallback start address is sector 1 }
BootSA = $00000;        { boot start address is sector 0 }
BBSize = 64;
NSAMSBOffset = 25;      { offset of Normal Start Address MS Byte in boot block }
CBootBlock : array[0..BBSize-1] of byte = ($FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
                                           $FF,$FF,$AA,$99,$55,$66,$31,$E1,
                                           $FF,$FF,$32,$61,$00,$00,$32,$81,
                                           $0B,$08,$32,$A1,$00,$00,$32,$C1,
                                           $0B,$01,$30,$A1,$00,$00,$33,$01,
                                           $21,$00,$32,$01,$00,$1F,$30,$A1,
                                           $00,$0E,$20,$00,$20,$00,$20,$00,
                                           $20,$00,$20,$00,$20,$00,$20,$00);

var
BootBlock : array[0..BBSize-1] of byte;
NormalSA : longint;      { normal start address is 1/2 way up }
NSAMSB : byte;
VerifyOnly : boolean;
CardNumber : word;
Parms : word;
StartAddress : longint;


FileName : string;
CFile : configfile;
CFileSize : longint;
Timeout : longint;
Fallback : boolean;
BBuf: array[0..FileBufferSize-1] of byte;

function OpenForRead(var fp: configfile; name: string): boolean;
begin
  Assign(fp,Name);
  {$I-}
  Reset(fp,1);
  {$I+}
  OpenForRead := IOResult = 0;
end { Open };

procedure Usage;
begin
  writeln;
  writeln(' NMFLASH - Writes config data to 5I24/5I25/6I25/7I90 EEPROM');
  writeln;
  writeln(' USAGE - NMFLASH file  [V]');
  writeln(' Where file is a VALID FPGA configuration file');
  writeln(' Trailing V invoke Verify only option');
  halt(2);
end;

procedure SetCSHigh;
begin
  Write32(BaseAddr+SPICSPort,1);
end;

procedure SetCSLow;
begin
  Write32(BaseAddr+SPICSPort,0);
end;

function WaitForSPIData : boolean;
var
loops: integer;
data : longint;
begin
  data := 0;
  loops := 0;
  while ((data and DAVMask) = 0) and (loops < 5000) do
  begin
    data := Read32(BaseAddr+SPICSPort);
    loops := loops +1;
  end;
  if loops = 5000 then WaitForSPIData := false else WaitForSPIData := true;
end;

procedure SendSPIByte( d: byte);
begin
  Write32(BaseAddr+SPISRegPort,d);
  if not WaitForSPIData then BarfOut('Timeout waiting for SPI Shift Register');
end;


function RecvSPIByte(d: byte) : byte;
var
data: longint;
begin
  Write32(BaseAddr+SPISRegPort,d);
  if not WaitForSPIData then BarfOut('Timeout waiting for SPI Shift Register');
  data := Read32(BaseAddr+SPISRegPort);
  RecvSPIByte := byte(data and $FF);
end;


{$I 25Mlowp.pas }

procedure Dump(sa:longint);
var
index : longint;

begin
  for index := sa to sa+255 do
  begin
    if (index and 15) = 0 then
    begin
      writeln;
      Hexprint(index,8);
      write(': ');
    end;
    Hexprint(ReadByte25(index),2);
    write(' ');
  end;
  writeln;
end;

procedure WriteBlock(add:longint;bufidx:word);
var
index : word;

begin
  WriteEnable25;
  Prefix25;
  PutByte25(PageProgCom);
  PutAddress25(add); { note that add 0..7 should be 0}
  for index :=  0 to PageSize -1 do
  begin
    PutByte25(BBuf[bufidx+index]);
  end;
  Suffix25;
  WaitForWrite25;
end;

function NextByte(n: byte) : byte;
var
index,abyte : byte;
bytesread : word;
begin
  for index := 1 to n do Blockread((CFile),abyte,1,bytesread);
  NextByte := abyte;
end;

function ReadString : string;
var
sleng,count : word;
tstring : string;
abyte: byte;
begin
  sleng := NextByte(1) * 256;
  sleng := sleng + NextByte(1);
  if (sleng > 255) then sleng := 255;
  tstring := '';
  for count := 1 to sleng do
  begin
    abyte := NextByte(1);
    if (abyte <> 0) then tstring := tstring + chr(abyte);
  end;
  ReadString := tstring;
end;

procedure PrintBitFileHeader;
var
sleng,bytesread : word;
tstring : string;
conflength : longint;
fbyte : byte;
ft : (bit,bin,unk);
begin
  ft := unk;
  if (NextByte(1) = 0) then
  begin
    if (Nextbyte(1) = 9) then
    begin
      writeln('Looks like a BIT file');
      fbyte := NextByte(9);  {skip over 9 header bytes}
      if (NextByte(1) = 0) then
      begin
        if (NextByte(1) = 1) then
        begin
          if (NextByte(1) = $61) then
          begin
            writeln('Design name: ',ReadString);
            fbyte := NextByte(1); {Skip over 'b'}
            writeln('Part name: ',ReadString);
            fbyte := NextByte(1); {Skip over 'c'}
            writeln('Design date: ',ReadString);
            fbyte := NextByte(1); {Skip over 'd'}
            writeln('Design time: ',ReadString);
            fbyte := NextByte(1);; {Skip over 'e'}
            conflength := longint(NextByte(1))*16777216;
            conflength := conflength +longint(NextByte(1))*65536;
            conflength := conflength +longint(NextByte(1))*256;
            conflength := conflength +longint(NextByte(1));
            writeln('Config Length: ',conflength);
            ft := bit;
          end; {valid bitfile header}
        end;
      end;
    end; {starting to look like a bit file }
  end; {looks like a bit file}
  if ft = unk then
  begin
    if (NextByte(1) = $FF) and (NextByte(1) = $FF)  and (NextByte(1) = $FF) and  (NextByte(1) = $FF) then
    begin
      writeln('Looks like a BIN file');
      Reset(Cfile,1);
      ft := bin;
    end;
  end;
  if ft = unk then
  begin
    writeln('Invalid bitfile header!');
    halt(2);
  end;
end;

procedure GetParms;
var
thefile : string;
begin
  Fallback := false;
  VerifyOnly := false;
  if ParamCount < 1 then Usage;
  thefile := paramStr(1);
  FileName := thefile;
  if Length(ParamStr(2)) <> 0 then
  begin
    if UpString(ParamStr(2)) = 'V' then VerifyOnly := true;
  end;
  if Length(ParamStr(3)) <> 0 then
  begin
    if UpString(ParamStr(3)) = 'V' then VerifyOnly := true;
  end;
  if Length(ParamStr(2)) <> 0 then
  begin
    if (ParamStr(2)) = 'FallBack' then Fallback := true;
  end;
  if Length(ParamStr(3)) <> 0 then
  begin
    if (ParamStr(3)) = 'FallBack' then Fallback := true;
  end;
  if not OpenForRead(CFile,FileName) then
  begin
    writeln('Can''t open configuration file');
    halt(2);
  end;
end;

procedure IdentifyEEPROM;
var
eepromid : byte;
begin
  SetCSHigh;
  eepromid:= ReadID25;
  if (eepromid <> OneMegID) and (eepromid <> TwoMegID) and
     (eepromid <> FourMegID) and (eepromid <> EightMegID) and
     (eepromid <> SixteenMegID) then
  begin
    write('Bad EEPROM ID, expected ');
    HexPrint(FourMegID,2);
    write(' or ');
    HexPrint(EightMegID,2);
    write(' or ');
    HexPrint(SixteenMegID,2);
    write(' but got ');
    HexPrint(eepromid,2);
    writeln;
    halt(2);
  end;
  if eepromid = FourMegID then
  begin
    writeln('4M Bit EEPROM Found');
    NormalSA := $40000;
  end;
  if eepromid = EightMegID then
  begin
    writeln('8M Bit EEPROM Found');
    NormalSA := $80000;
  end;
  if eepromid = SixteenMegID then
  begin
    writeln('16M Bit EEPROM Found');
    NormalSA := $100000;
  end;
  NSAMSB := (NormalSA shr 16);
end;

procedure MakeBootBlock;
var index : word;
begin
  for index := 0 to BBSize -1 do BootBlock[index] := CBootBlock[index];
  BootBlock[NSAMSBOffset] := NSAMSB;  { insert top address byte to match EEPROM size }
end;

procedure StartProgramming(sa: longint);
var
sectorsize,esectors,sector,secadd,esspace : longint;
begin
  SetCSHigh;
  sectorsize := 65536;
  esspace := (NormalSA div sectorsize);
  if sa = FallBackSA then esspace := esspace - 1;
  writeln('About to erase EEPROM sectors =>  ');
  esectors := (CFilesize-1) div sectorsize;
  if esectors > esspace then BarfOut('File Size too large to fit');
  secadd := sa;
  for sector := 0 to esectors do
  begin
    EraseSector25(secadd);
    secadd := secadd + sectorsize;
    write('Sector ',sector+(sa div sectorsize),' erased   ',chr(13));
  end;
  writeln;
  if sa = FallBackSA then
     writeln('Fallback area of EEPROM erased')
  else
     writeln('Configuration area of EEPROM erased');
  SetCSHigh;
end;

procedure DoneProgramming;
begin
  SetCSHigh;
end;

procedure VerifyIt;
var
index,bindex : longint;
bytesread : word;
rdata : byte;
begin
  if OpenForRead(CFile,FileName) then
  begin
    IdentifyEEPROM;
    reset(CFile,1);
    CFileSize := FileSize(CFile);
    PrintBitFileHeader;
    if Fallback then index := FallbackSA else index := NormalSA;
    while not EOF(CFile) do
    begin
      bytesread := 0;
      blockread(CFile,BBuf,FileBufferSize,bytesread);
      bindex := 0;
      while bindex < bytesread do
      begin
        rdata := ReadByte25(bindex+index);
        if BBuf[bindex] <> rdata then
        begin
          write('Error at ');
          HexPrint(index+bindex,8);
          write(' expected: ');
          Hexprint(BBuf[bindex],2);
          write(' but read: ');
          HexPrint(rdata,2);
          writeln;
          dump(bindex+index);
          halt(2);
        end;
        bindex := bindex + 1;
      end;
    index := index + FileBufferSize;
    write('V ');
    end;
  end
  else
  begin
    writeln('Can''t open configuration file');
    halt(2);
  end;
end;

procedure WriteBoot;
var index : word;
begin
  writeln('Erasing sector 0 for boot block');
  EraseSector25(BootSA);
  for index := 0 to BBSize -1 do BBuf[index] := BootBlock[index];
  for index := BBsize to PageSize-1 do BBuf[index] := 0;
  WriteBlock(0,0);
  writeln('BootBlock installed');
end;

function CheckBoot : boolean;
var
index : longint;
bootok: boolean;
begin
  bootok := true;
  for index := 0 to BBSize -1 do
  begin
    if ReadByte25(index) <> BootBlock[index] then bootok := false;
  end;
  CheckBoot := bootok;
end;


procedure WriteIt;
var
cbyte : byte;
bytesread,index : word;
bytecount : longint;
eepromadd : longint;
begin
  if OpenForRead(CFile,FileName) then
  begin
    IdentifyEEPROM;
    MakeBootBlock;
    if not CheckBoot then WriteBoot else writeln('BootSector OK');
    if not CheckBoot then  BarfOut('Failed to write valid boot sector');
    reset(CFile,1);
    CFileSize := FileSize(CFile);
    PrintBitfileHeader;
    if Fallback then
    begin
      StartAddress := FallbackSA;
      writeln('Writing fallback configuration');
    end
    else
    begin
      StartAddress := NormalSA;
      writeln('Writing user configuration');
    end;
    StartProgramming(StartAddress);
    writeln(':');
    eepromadd:= StartAddress;
    while not EOF(CFile) do
    begin
      bytesread := 0;
      blockread(CFile,BBuf,FileBufferSize,bytesread);
      index := 0;
      write('W ');
      while index < bytesread do
      begin
        WriteBlock(eepromadd,index);
        index := index + PageSize;
        eepromadd := eepromadd + Pagesize;
      end;
    end;
  end
  else
  begin
    writeln('Can''t open configuration file');
    halt(2);
  end;
  writeln;
  DoneProgramming;
end;

begin
  GetParms;
  GetOurEnv;
  if not InitializeInterface(message) then bumout(message);
  if VerifyOnly then VerifyIt else WriteIt;
  writeln('Done');
  CloseInterface;
  halt(0);
end.
