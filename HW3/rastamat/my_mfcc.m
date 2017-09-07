function [cepDpDD,cep2,del,ddel] = my_mfcc(y, fs)

% Calculate 12th order PLP features without RASTA
[cep2, spec2] = rastaplp(y, fs, 0, 12);
% Append deltas and double-deltas onto the cepstral vectors
del = deltas(cep2);
% Double deltas are deltas applied twice with a shorter window
ddel = deltas(deltas(cep2,5),5);
% Composite, 39-element feature vector, just like we use for speech recognition
cepDpDD = [cep2;del;ddel];

% cep2 => 13-element feature vector ; del => 13-element feature vector ;
% ddel=> 13-element feature vector

% cep2,del,ddel => 13-element feature vector X frame number   double
