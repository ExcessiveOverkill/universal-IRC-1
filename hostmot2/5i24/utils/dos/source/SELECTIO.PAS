{$IFDEF SOFTDMC}
  {$I MOTIO5.PAS}
  {$DEFINE FIFO}
{$ELSE}
  {$IFDEF THREEC20}
    {I MOTPARMD.PAS} { for 3C20 }
    {$DEFINE EEPROM}
  {$ELSE}
    {$IFDEF EIGHTI20}
      {$I 8I20PARM.PAS}
      {$DEFINE EEPROM}
    {$ELSE}
      {$IFDEF SEVENI43}
        {$I MOTIO5.PAS}
        {$DEFINE FIFO}
      {$ELSE}
        {$IFDEF EIGHTC20}
          {$I 8C20PARM.PAS}
          {$DEFINE EEPROM}
        {$ELSE}
          {$IFDEF EIGHTI40}
            {$I 8I40PARM.PAS}
            {$DEFINE EEPROM}
          {$ELSE}
            {$IFDEF SEVENI64}
              {$I 7I64PARM.PAS}
            {$ELSE}
              {$IFDEF GENERIC}
                {}
              {$ELSE}
                {$IFDEF GENPIC}
                  {}
                {$ELSE}

              BUMOUT CARD NOT DEFINED

                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
