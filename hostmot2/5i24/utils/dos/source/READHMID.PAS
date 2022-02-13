
program ReadHM2IDROM;


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

procedure Error(err : integer);
begin
  writeln(errorrecord[err].errstr);
  halt(2);
end;

var
DoXML : boolean;
XMLIndent : word;
CardNumber : integer;
const
XMLTab = 4;

procedure Barfout(es:string);
begin
  writeln;
  writeln(es);
  halt(2);
end;

procedure FixCRT;
{ Fix re-direction when using CRT unit }
begin
  assign(input,'');
  reset(input);
  assign(output,'');
  rewrite(output);
end;

procedure XTab(indent:integer);
var spaces : integer;
begin
  for spaces := 1 to indent do write(' ');
end;

procedure WriteLF(indent: integer);
begin
  write(chr(10));
  XMLIndent := XMLIndent + indent;
  XTab(XMLIndent*XMLTab);
end;

procedure PrintAsText(d: longint);
begin
  write(char(LongIntByteRec(d).Byte0));
  write(char(LongIntByteRec(d).Byte1));
  write(char(LongIntByteRec(d).Byte2));
  write(char(LongIntByteRec(d).Byte3));
end;

procedure PrintAsLCText(d: longint);
var ns : string;
begin
  ns :='';
  ns := ns +char(LongIntByteRec(d).Byte0);
  ns := ns +char(LongIntByteRec(d).Byte1);
  ns := ns +char(LongIntByteRec(d).Byte2);
  ns := ns +char(LongIntByteRec(d).Byte3);
  write(LowString(ns));
end;

procedure PrintModuleName(gtag,pad:byte);
var
index : byte;
foundit : boolean;
begin
  foundit := false;
  for index := 1 to MaxTags do
  begin
    if FNames[index].FTag = gtag then
    begin
      write(PadWithSpaces(FNames[index].FName,pad));
      foundit := true;
    end;
  end;
  if foundit = false then write(PadWithSpaces('Unknown',pad));
end;

procedure PrintModuleNameX(gtag,pad:byte);
var
index : byte;
foundit : boolean;
begin
  foundit := false;
  for index := 1 to MaxTags do
  begin
    if FNamesX[index].FTag = gtag then
    begin
      write(PadWithSpaces(FNamesX[index].FName,pad));
      foundit := true;
    end;
  end;
  if foundit = false then write(PadWithSpaces('Unknown',pad));
end;

procedure PrintPinName(gtag,n,pad : byte);
var
index,num,chan : byte;
chans : string;
foundit : boolean;

begin
  foundit := false;
  { normal modules are like this }
  num := n and OutputMask;
  for index := 1 to MaxTags do
  begin
    if PNames[index].FTag = gtag then
    begin
      if gtag = SSerialTag then
      begin
        chan := n and $0F;
        str(chan,chans);
        if n and $F0 = $00 then write(PadWithSpaces(PNames[index].Names[1]+chans,pad));
        if n and $F0 = $80 then write(PadWithSpaces(PNames[index].Names[2]+chans,pad));
        if n and $F0 = $90 then write(PadWithSpaces(PNames[index].Names[3]+chans,pad));
        if n = $A1         then write(PadWithSpaces(PNames[index].Names[4],pad));
        foundit := true;
      end;
      if gtag = DAQFIFOTag then
      begin
        chan := n and $1F;
        str(chan,chans);
        if n and $E0 = $00 then write(PadWithSpaces(PNames[index].Names[1]+chans,pad));
        if n = $41 then write(PadWithSpaces(PNames[index].Names[2],pad));
        if n = $81 then write(PadWithSpaces(PNames[index].Names[3],pad));
        foundit := true;
      end;
      if gtag = TwiddlerTag then
      begin
        chan := n and $1F;
        str(chan,chans);
        if n and $C0 = $00 then write(PadWithSpaces(PNames[index].Names[1]+chans,pad));
        if n and $C0 = $C0 then write(PadWithSpaces(PNames[index].Names[2]+chans,pad));
        if n and $C0 = $80 then write(PadWithSpaces(PNames[index].Names[3]+chans,pad));
        foundit := true;
      end;
      if gtag = BinOscTag then
      begin
        chan := n and $1F;
        str(chan,chans);
        if n and $80 = $80 then write(PadWithSpaces(PNames[index].Names[1]+chans,pad));
        foundit := true;
      end;
      if foundit = false then
      begin
        write(PadWithSpaces(PNames[index].Names[num],pad));
        foundit := true;
      end;
    end;
  end;
  if foundit = false then write(PadWithSpaces('Unknown',pad));
end;

procedure PrintPinNameX(gtag,n,pad : byte);
var
index,num,chan : byte;
chans : string;
foundit : boolean;

begin
  foundit := false;
  { normal modules are like this }
  num := n and OutputMask;
  for index := 1 to MaxTags do
  begin
    if PNamesXML[index].FTag = gtag then
    begin
      if gtag = SSerialTag then
      begin
        chan := n and $0F;
        str(chan,chans);
        if n and $F0 = $00 then write(PadWithSpaces(PNamesXML[index].Names[1]+chans,pad));
        if n and $F0 = $80 then write(PadWithSpaces(PNamesXML[index].Names[2]+chans,pad));
        if n and $F0 = $90 then write(PadWithSpaces(PNamesXML[index].Names[3]+chans,pad));
        if n = $A1         then write(PadWithSpaces(PNamesXML[index].Names[4],pad));
        foundit := true;
      end;
      if gtag = DAQFIFOTag then
      begin
        chan := n and $1F;
        str(chan,chans);
        if n and $E0 = $00 then write(PadWithSpaces(PNamesXML[index].Names[1]+chans,pad));
        if n = $41 then write(PadWithSpaces(PNamesXML[index].Names[2],pad));
        if n = $81 then write(PadWithSpaces(PNamesXML[index].Names[3],pad));
        foundit := true;
      end;
      if gtag = TwiddlerTag then
      begin
        chan := n and $1F;
        str(chan,chans);
        if n and $C0 = $00 then write(PadWithSpaces(PNamesXML[index].Names[1]+chans,pad));
        if n and $C0 = $C0 then write(PadWithSpaces(PNamesXML[index].Names[2]+chans,pad));
        if n and $C0 = $80 then write(PadWithSpaces(PNamesXML[index].Names[3]+chans,pad));
        foundit := true;
      end;
      if gtag = BinOscTag then
      begin
        chan := n and $1F;
        str(chan,chans);
        if n and $80 = $80 then write(PadWithSpaces(PNamesXML[index].Names[1]+chans,pad));
        foundit := true;
      end;
      if foundit = false then
      begin
        write(PadWithSpaces(PNamesXML[index].Names[num],pad));
        foundit := true;
      end;
    end;
  end;
  if foundit = false then write(PadWithSpaces('Unknown',pad));
end;

procedure PrintConnectorName(bn : longint;p:byte);
var index : byte;
begin
  for index := 1 to Boards do
  begin
    if ConnectorNames[index].BoardName = bn then
    begin
      write(ConnectorNames[index].ConName[p]);
    end;
  end;
end;

function PinNumber(io,pw: byte) : integer;
var pn,mio : byte;
begin
  pn := 0;
  if pw = 24 then pn := (((io-1) mod pw)*2) +1; { for 50 pin 24 I/O pinout}
  if pw = 17 then                               { for printer port 17 I/O pinout }
  begin
    mio := (io-1) mod pw;
    if mio > 7 then pn := mio -3 else
    begin
      if (mio and 1) = 0 then pn := (mio div 2)+1 else pn := (mio div 2) +14;
    end;
  end;
  PinNumber := pn;
end;

procedure PrintBoardName;
begin
  with IDROMHeader do
  begin
    write('  BoardName : ');
    PrintAsText(BoardNameLow);
    PrintAsText(BoardNameHigh);
  end;
end;

procedure PrintHeader;
begin
  with IDROMHeader do
  begin
    if (IDROMType <> IDROMStyle0) and (IDROMType <> IDROMStyle1) then Barfout('Wrong IDROM Format!');
    ModuleOffset := ModulePointer div 4;
    PinDescOffset := PinDescPointer div 4;
    writeln;
    writeln('General configuration information:');
    writeln;
    PrintBoardName;
    writeln;
    writeln('  FPGA Size: ',FPGASize,' KGates');
    writeln('  FPGA Pins: ',FPGAPins);
    writeln('  Number of IO Ports: ',IOPorts);
    writeln('  Width of one I/O port: ',PortWidth);
    writeln('  Clock Low frequency: ',ClockLow/1e6:3:4,' MHz') ;
    writeln('  Clock High frequency: ',ClockHigh/1e6:3:4,' MHz') ;
    writeln('  IDROM Type: ',IDROMType) ;
    writeln('  Instance Stride 0: ',InstStride0) ;
    writeln('  Instance Stride 1: ',InstStride1) ;
    writeln('  Register Stride 0: ',RegStride0) ;
    writeln('  Register Stride 1: ',RegStride1) ;
    writeln('  IDROM Type: ',IDROMType) ;
  end;
end;

procedure PrintModules;
var index : integer;
begin
  for index := 0 to MaxModules*3 -1 do
  begin
    ModulesAsArray[index] := IDROMAsArray[index+ModuleOffset];
  end;
  Modules := ModuleType(ModulesAsArray);
  index := 0;
  writeln;
  writeln('Modules in configuration: ');
  repeat
    with Modules[index] do
    begin
      writeln;
      write('  Module: ');
      PrintModuleName(GTag,0);
      writeln;
      write('  There are ',NumInstances,' of ');
      PrintModuleName(GTag,0);
      writeln(' in configuration');
      writeln('  Version: ',Version);
      writeln('  Registers: ',NumRegisters);
      write('  BaseAddress: ');
      HexPrint(BaseAddr,4);
      writeln;
      if Clock = ClockLowTag then
        writeln('  ClockFrequency: ',IDROMHeader.ClockLow/1e6:3:3,' MHz')
      else
        writeln('  ClockFrequency: ',IDROMHeader.ClockHigh/1e6:3:3,' MHz');
      index := index+1;
      if (Strides and $0F) = 0 then
         writeln('  Register Stride: ',IDROMHeader.RegStride0,' bytes')
      else
         writeln('  Register Stride: ',IDROMHeader.RegStride1,' bytes');
      if (Strides and $F0) = 0 then
         writeln('  Instance Stride: ',IDROMHeader.InstStride0,' bytes')
      else
         writeln('  Instance Stride: ',IDROMHeader.InstStride1,' bytes');
    end;
  until Modules[index].GTag = 0;
end;

procedure PrintPins;
var index : integer;
begin
  for index := 0 to MaxPins-1 do
  begin
    PinDescsAsArray[index] := IDROMAsArray[index+PinDescOffset];
  end;
  PinDescs := PinDescType(PinDescsAsArray);
  writeln;
  writeln('Configuration pin-out: ');
  for index := 1 to IDROMHeader.IOWidth do
  begin
    with PinDescs[index] do
    begin
      if ((index-1) mod IDROMHeader.PortWidth) = 0 then
      begin
        writeln;
        write('IO Connections for ');
        PrintConnectorName(IDROMHeader.BoardNameHigh,((index -1) div IDROMHeader.PortWidth+1));
        writeln;
        writeln('Pin#  I/O   Pri. func    Sec. func       Chan      Pin func        Pin Dir');
        writeln;
      end;
      write(PinNumber(index,IDROMHeader.PortWidth):2);
      write('    ',index-1:3,'   ');
      PrintModuleName(PTag,8);
      write('     ');
      if GTag <> $00 then
      begin
        PrintModuleName(Gtag,15);
        if (Chan and GlobalMarker) <> 0 then
        begin
          write('     Global    ');
        end
        else
        begin
          write(' ',Chan:2,'        ');
        end;
        PrintPinName(Gtag,PNumber,12);
        if PNumber and OutputMarker <> 0 then writeln('    (Out)') else writeln('    (In)');
      end
      else writeln('None');
    end;
  end;
end;

procedure PrintHeaderX;
begin
  with IDROMHeader do
  begin
    if (IDROMType <> IDROMStyle0) and (IDROMType <> IDROMStyle1) then Barfout('Wrong IDROM Format!');
    ModuleOffset := ModulePointer div 4;
    PinDescOffset := PinDescPointer div 4;
    XMLIndent := 0;
    write('<?xml version="1.0"?>');
    writeLF(0);
    write('<hostmot2>');
    writeLF(1);
    write('<boardname>');
    PrintAsLCText(BoardNameHigh);
    write('</boardname>');
    writeLF(0);
    write('<ioports>',IOPorts,'</ioports>');
    writeLF(0);
    write('<iowidth>',IOWidth,'</iowidth>');
    writeLF(0);
    write('<portwidth>',PortWidth,'</portwidth>');
    writeLF(0);
    write('<clocklow>',ClockLow:8,'</clocklow>');
    writeLF(0);
    write('<clockhigh>',ClockHigh:8,'</clockhigh>');
    writeLF(0);
  end;
end;

procedure PrintModulesX;
var index : integer;
begin
  for index := 0 to MaxModules*3 -1 do
  begin
    ModulesAsArray[index] := IDROMAsArray[index+ModuleOffset];
  end;
  Modules := ModuleType(ModulesAsArray);
  index := 1;
  write('<modules>');
  writeLF(1);
  repeat
    with Modules[index] do
    begin
      write('<module>');
      writeLF(1);
      write('<tagname>');
      PrintModuleNameX(GTag,0);
      write('</tagname>');
      writeLF(0);
      write('<numinstances>',NumInstances:2,'</numinstances>');
      writeLF(-1);
      write('</module>');
      index := index +1;
      if Modules[index].GTag <> 0 then writeLF(0);
    end;
  until Modules[index].GTag = 0;
  write('<module>');
  writeLF(1);
  write('<tagname>None</tagname>');
  writeLF(0);
  write('<numinstances> 1</numinstances>');
  writeLF(-1);
  write('</module>');
  index := index +1;
  writeLF(-1);
  write('</modules>');
  writeLF(0);
end;

procedure PrintPinsX;
var
index : integer;
pindir : string;
begin
  for index := 0 to MaxPins-1 do
  begin
    PinDescsAsArray[index] := IDROMAsArray[index+PinDescOffset];
  end;
  PinDescs := PinDescType(PinDescsAsArray);
  write('<pins>');
  writeLF(1);
  for index := 1 to IDROMHeader.IOWidth do
  begin
    with PinDescs[index] do
    begin
      write('<pin>');
      writeLF(1);
      write('<connector>');
      PrintConnectorName(IDROMHeader.BoardNameHigh,((index -1) div IDROMHeader.PortWidth+1));
      write('</connector>');
      writeLF(0);
      if PNumber and OutputMarker <> 0 then pindir := '(out)' else pindir := '(in)';
      if GTag <> $00 then
      begin
        write('<secondarymodulename>');
        PrintModuleName(GTag,0);
        write('</secondarymodulename>');
        writeLF(0);
        write('<secondaryfunctionname>');
        PrintPinNameX(Gtag,PNumber,0);
        write(' ',pindir,'</secondaryfunctionname>');
        writeLF(0);
        write('<secondaryinstance>',chan:2,'</secondaryinstance>');
      end
      else
      begin
        write('<secondarymodulename>None</secondarymodulename>');
        writeLF(0);
        write('<secondaryfunctionname>0</secondaryfunctionname>');
        writeLF(0);
        write('<secondaryinstance>',0,'</secondaryinstance>');
      end;
      writeLF(-1);
      write('</pin>');
      if index <>  IDROMHeader.IOWidth then writeLF(0)
    end;
  end;
  writeLF(-1);
  write('</pins>');
  writeLF(-1);
  write('</hostmot2>');
end;

procedure ScanParms;
var
data,index : longint;
connector,pin : byte;
begin
  data := Read32(HM2CookieOffset);
  if data <> HM2Cookie then BarfOut('No HM2 Hardware Found');
  data := Read32(HostMotNameLowOffset);
  if not DoXML then
  begin
    write('Configuration Name: ');
    PrintAsText(data);
    data := Read32(HostMotNameHighOffset);
    PrintAsText(data);
    writeln;
  end;
  data := Read32(IDROMPointer);
  IDROMOffset := data;
  for index := 0 to IDROMSize-1 do
  begin
    data := Read32(IDROMOffset+index*4);
    IDROMAsArray[index] := data
  end;
  for index := 0 to IDROMHeaderSize-1 do
  begin
    IDROMHeaderAsArray[index] := IDROMAsArray[index];
  end;
  IDROMHeader := IDROMHeaderType(IDROMHeaderAsArray);
  if DoXML then
  begin
    PrintHeaderX;
    PrintModulesX;
    PrintPinsX;
  end
  else
  begin
    PrintHeader;
    PrintModules;
    PrintPins;
  end;
end;

procedure GetParm;
var retcode : integer;
begin
  DoXML := false;
  if ParamCount >0 then
  begin
    val(ParamStr(1),CardNumber,retcode);
    if retcode <> 0 then BarfOut('Invalid card #');
  end;
  if ParamCount >1 then
  begin
    if UpString(ParamStr(2)) = 'XML' then DoXML := true;
  end;
end;

begin
  FixCRT;
  GetOurEnv;
  if not InitializeInterface(message) then bumout(message);
  GetParm;
  ScanParms;
end.
