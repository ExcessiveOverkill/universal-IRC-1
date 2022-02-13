const
N056VendorID = $10B5;
N056DeviceID = $9056;

N056PCICR = $04;            { PCI Status and control Register }
N056PCIBaseAddress0 = $10;  { memory access to local config regs }
N056PCIBaseAddress1 = $14;  { I/O access to local config regs }
N056PCIBaseAddress2 = $18;  { local address space 0 }
N056PCIBaseAddress3 = $1C;  { local address space 1 }
N056PCIIntRegister  = $3C;  { interrupt routing register }
N056GPIOControlReg = $6C;
N056GPIOControlRegTop = $6E;

{ at N056GPIOControlRegTop }
N056UserOMask = $0001;
N056UserIMask = $0002;
N056UserIIsInputMask : word = $0004;
N056UserOIsOutputMask : word = $0008;

N056EECLKMask : word = $0100;  { will probably just use VPD access }
N056EECSMask : word = $0200;   { due to the fact that the 9056s muxed  }
N056EEDIMask : word = $0400;   { EEDI/EEDO messes up normal EEPROM access}
N056EEDOMask : word = $0800;

N056VPDIDNDC : word = $4C;
N056VPDAddr  : word = $4E;
N056VPDData  : word = $50;
N056VPDFMask : word = $8000;   {F bit in VPD address register }

N056LCSPROT  : word = $0E;

{ 3X20 Specific masks for access to PCI bridge GPIO bits... }

DoneMask_56 : word    = N056UserIMask; { Read at N056GPIOControlRegTop}
ProgramMask_56 : word = N056UserOMask; { Written at N056GPIOControlRegTop}

{DMA registers}

N056DMAMode0Register = $80;
N056DMAPAdr0Register = $84;
N056DMALAdr0Register = $88;
N056DMASiz0Register = $8C;
N056DMADPr0Register = $90;
N056DMACSR0Register = $A8;  {Byte register!}
N056DMADAC0Register = $B4;

N056DMAMode1Register = $94;
N056DMAPAdr1Register = $98;
N056DMALAdr1Register = $9C;
N056DMASiz1Register = $A0;
N056DMADPr1Register = $A4;
N056DMACSR1Register = $A9;  {Byte register!}
N056DMADAC1Register = $B8;

N056DMAThrRegister = $B0;
