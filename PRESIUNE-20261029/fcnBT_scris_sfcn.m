function fcnBT_scris_sfcn(block)
% Level-2 MATLAB file S-Function for times two demo.

%   Copyright 1990-2009 The MathWorks, Inc.

  setup(block);
  
%endfunction

function setup(block)
  global dispoz
  % if (~isempty(dispoz))
  listaBT=bluetoothlist("Timeout",20); %10 secunde; ar trebui sa scrie ready to connect, daca nu, trebuie paired din bara de start la bluetooth
  if isempty(find(strcmp(listaBT.Name,"PicoW Serial 28:CD:C1:01:75:AB"),1))
      disp("#### ATENTIE: NU AM GASIT DEVICEUL IN LISTA DE BLUETOOTH ####")
  else
      if (listaBT.Status(find(strcmp(listaBT.Name,"PicoW Serial 28:CD:C1:01:75:AB"),1))=="Connected")
          disp("###### ESTE DEJA CONECTAT ######")
          if isempty(dispoz)
              disp("#### DIN PACATE ESTE CONECTAT DAR VARIABILA GLOBALA HANDLE PENTRU PICO BLUETOOTH A FOST STERS SI NU PREA MAI AVEM CE FACE, INCERCAT DIVERSE DACA NU, RESTART CALC ####")
          else
              disp("##### ESTE CONECTAT DAR SUNTEM NOROCOSI CA VARIABILA GLOBALA HANDLE PENTRU PICO BLUETOOTH ESTE INCA IN MEMORIE ######")
          end
      else
          dispoz = bluetooth("28CDC10175AB",1,"Timeout",10); % 1 este canalul default
          configureTerminator(dispoz,"CR");
      end
  end
   % dispoz = bluetooth("28CDC1017C0B",1,"Timeout",10); % 1 este canalul default
   % configureTerminator(dispoz,"CR");
   % end
  %% Register number of input and output ports
  block.NumInputPorts  = 1;
  block.NumOutputPorts = 1;

  %% Setup functional port properties to dynamically
  %% inherited.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
 
  block.InputPort(1).DirectFeedthrough = true;
  
  %% Set block sample time to inherited
  block.SampleTimes = [-1 0];
  
  %% Set the block simStateCompliance to default (i.e., same as a built-in block)
  block.SimStateCompliance = 'DefaultSimState';

  %% Run accelerator on TLC
  block.SetAccelRunOnTLC(true);
  
  %% Register methods
  block.RegBlockMethod('Outputs',                 @Output);  
  
%endfunction

function Output(block)
  global dispoz
  block.OutputPort(1).Data = 1; % nu face practic nimic
  write(dispoz,uint8(block.InputPort(1).Data));
  
%endfunction

