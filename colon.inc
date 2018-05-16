%define po 0

%macro colon 2
%%po: dq po 
db %1, 0
xt_ %+ %2:

%define po %%po
%endmacro
