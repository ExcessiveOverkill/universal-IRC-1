{$I HM2ID.pas}

procedure FillHM2Array;
var
data,index : longint;
connector,pin : byte;
begin
  data := Read32(HM2CookieOffset);
  if data <> HM2Cookie then
  begin
    Writeln('No HM2 Hardware Found');
    halt(2);
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
  ModuleOffset := IDROMHeader.ModulePointer div 4;
  PinDescOffset := IDROMHeader.PinDescPointer div 4;
end;

procedure MakeOutputMasks(ourgtag : byte;ourchan : byte);
var
index : word;
mask : longint;
maskptr : word;
begin
  for index := 0 to MaxPins-1 do
  begin
    PinDescsAsArray[index] := IDROMAsArray[index+PinDescOffset];
  end;
  PinDescs := PinDescType(PinDescsAsArray);
  for index := 1 to IDROMHeader.IOWidth do
  begin
    with PinDescs[index] do
    begin
      {writeln(Gtag,' ',Pnumber);}
      if ((index-1) mod IDROMHeader.PortWidth) = 0 then mask := 1;
      if (GTag = ourgtag) and (Chan = ourchan) and (Pnumber and byte(OutputMarker) <> 0) then
      begin
        maskptr := (index-1) div IDROMHeader.PortWidth;
        OutputMasks[maskptr] := OutputMasks[maskptr] or mask;
      end;
    end;
    mask := mask shl 1;
  end;
end;

procedure SetAllHM2OutputMasks;
var
index : word;
mask : longint;
maskptr : word;
begin
  for index := 0 to MaxPins-1 do
  begin
    PinDescsAsArray[index] := IDROMAsArray[index+PinDescOffset];
  end;
  PinDescs := PinDescType(PinDescsAsArray);
  for index := 1 to IDROMHeader.IOWidth do
  begin
    with PinDescs[index] do
    begin
      if ((index-1) mod IDROMHeader.PortWidth) = 0 then mask := 1;
      if (Pnumber and byte(OutputMarker) <> 0) then
      begin
        maskptr := (index-1) div IDROMHeader.PortWidth;
        OutputMasks[maskptr] := OutputMasks[maskptr] or mask;
      end;
    end;
    mask := mask shl 1;
  end;
end;

procedure UpdateAllHM2OutputMasks;
var
index : word;
begin
  for index := 0 to MaxConns -1 do
  begin
    if OutputMasks[index] <> 0 then
    begin
      Write32($1100+index*4,OutputMasks[index]); { ddr }
      Write32($1200+index*4,OutputMasks[index]); { altsource }
    end;
  end;
end;

procedure ZeroMasks;
var index : word;
begin
  for index := 0 to MaxConns -1 do OutputMasks[index] := 0;
end;

function GetModuleInfo(module : byte; var base : word; var numregs : byte) : boolean;
var
foundit : boolean;
index : word;
begin
  foundit := false;
  base := 0;
  numregs := 0;
  for index := 0 to MaxModules*3 -1 do
  begin
    ModulesAsArray[index] := IDROMAsArray[index+ModuleOffset];
  end;
  Modules := ModuleType(ModulesAsArray);
  for index := 0 to MaxModules -1 do
  begin
    if Modules[index].GTag = module then
    begin
      foundit := true;
      base := Modules[index].BaseAddr;
      numregs := Modules[index].NumRegisters;
    end;
  end;
  GetModuleInfo := foundit;
end;

function GetModuleStrides(module : byte; var regstride : word; var inststride : word) : boolean;
var
foundit : boolean;
mstrides : byte;
index : word;
begin
  foundit := false;
  inststride := 0;
  regstride := 0;
  for index := 0 to MaxModules*3 -1 do
  begin
    ModulesAsArray[index] := IDROMAsArray[index+ModuleOffset];
  end;
  Modules := ModuleType(ModulesAsArray);
  for index := 0 to MaxModules -1 do
  begin
    if Modules[index].GTag = module then
    begin
      foundit := true;
      mstrides := Modules[index].Strides;
    end;
  end;
  if (mstrides and $0F) = 0 then
    regstride := IDROMHeader.RegStride0
  else
    regstride := IDROMHeader.RegStride1;
  if (mstrides and $F0) = 0 then
    inststride := IDROMHeader.InstStride0
  else
    inststride := IDROMHeader.InstStride1;

  GetModuleStrides := foundit;
end;

