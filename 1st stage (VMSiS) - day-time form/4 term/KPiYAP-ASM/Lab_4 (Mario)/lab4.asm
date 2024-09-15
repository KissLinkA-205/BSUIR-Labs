.model small
.stack 100h

.data

level db ' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0BBh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0FFh,' ',0BBh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0BBh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',0FFh,' ',0FFh,' ',0BBh,' ',0FFh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',033h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'*',06Fh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',088h,' ',0FFh,' ',088h,' ',0FFh,' ',088h
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'*',06Fh,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0FFh,' ',088h,' ',0FFh,' ',088h,' ',0FFh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',088h,' ',0FFh,' ',088h,' ',0FFh,' ',088h
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,'*',06Fh,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,'*',06Fh,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,'$',03Eh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h
      db ' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0AAh,' ',0AAh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h
      db ' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',066h,' ',0BBh,' ',0BBh,' ',0BBh,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h,' ',066h

baseLevel db 5500 dup(?)
                                                                                                                                                                                                                                                                       
    MarioPositionX dw 2       ;220 x 25      ;1-blue, 2-green, 3-blue, 4-red, 5-purple, 6-brown, 7-grey, 8-black
    MarioPositionY dw 22                     ;9-blue, A-green, B-blue, C-red, D-purple, F-grey
	
	xMovement dw 0
    yMovement dw 0
    
    bonusCounter dw 0
    lifes db 0
    
    levelPosition dw 2 
    coins1 db 0
    coins2 db 0
    
    mobeMovement dw 2
    mobePosition dw 0
    
    xMobe1 dw 25
    Mobe1 db 0CCh
    yMobe1 dw 23
    
    xMobe2 dw 115
    Mobe2 db 0CCh
    yMobe2 dw 18
    
    xMobe3 dw 51
    Mobe3 db 0CCh
    yMobe3 dw 6 
    
    xMobe4 dw 163
    Mobe4 db 0CCh
    yMobe4 dw 23
    
    xMobe5 dw 187 
    Mobe5 db 0CCh
    yMobe5 dw 23
    
    xMobe6 dw 161
    Mobe6 db 0CCh
    yMobe6 dw 16
	                            ;0CCh
.code                           ;011h

DisplayCleanScreen proc
    mov bx,0
    mov ah,00
    mov al,01
    int 10h 
    
    mov ax,0B800h
    mov es,ax
    
    mov cx,1000
    mov bx,0
Outp:
    mov es:bx, ' '
    inc bx
    mov es:bx, 088h
    inc bx
loop Outp
    ret
DisplayCleanScreen endp

DisplayStart proc
    
    push ax
    push bx
    push cx
    push ds
    
    mov bx,0
    mov ah,00
    mov al,01
    int 10h
    
    mov ax, 0B800h
    mov ds, ax
    
    call DisplayCleanScreen
    
    mov ds:[196],'M'
    mov ds:[197],00001110b
    mov ds:[198],'A'
    mov ds:[199],00001110b
    mov ds:[200],'R'
    mov ds:[201],00001110b
    mov ds:[202],'I'
    mov ds:[203],00001110b
    mov ds:[204],'O'
    mov ds:[205],00001110b
    
    mov ds:[506],'C'
    mov ds:[507],00001111b
    mov ds:[508],'o'
    mov ds:[509],00001111b
    mov ds:[510],'n'
    mov ds:[511],00001111b
    mov ds:[512],'t'
    mov ds:[513],00001111b
    mov ds:[514],'r'
    mov ds:[515],00001111b
    mov ds:[516],'o'
    mov ds:[517],00001111b
    mov ds:[518],'l'
    mov ds:[519],00001111b
    mov ds:[520],'s'
    mov ds:[521],00001111b
    mov ds:[522],':'
    mov ds:[523],00001111b 
    
    mov ds:[666],'A'
    mov ds:[667],00000111b
    mov ds:[668],'/'
    mov ds:[669],00000111b
    mov ds:[670],'D'
    mov ds:[671],00000111b
    mov ds:[674],'-'
    mov ds:[675],00000111b
    mov ds:[678],'m'
    mov ds:[679],00000111b
    mov ds:[680],'o'
    mov ds:[681],00000111b
    mov ds:[682],'v'
    mov ds:[683],00000111b
    mov ds:[684],'e'
    mov ds:[685],00000111b
    
    mov ds:[826],'S'
    mov ds:[827],00000111b
    mov ds:[828],'p'
    mov ds:[829],00000111b
    mov ds:[830],'a'
    mov ds:[831],00000111b
    mov ds:[832],'c'
    mov ds:[833],00000111b
    mov ds:[834],'e'
    mov ds:[835],00000111b
    mov ds:[838],'-'
    mov ds:[839],00000111b
    mov ds:[842],'j'
    mov ds:[843],00000111b
    mov ds:[844],'u'
    mov ds:[845],00000111b
    mov ds:[846],'m'
    mov ds:[847],00000111b
    mov ds:[848],'p'
    mov ds:[849],00000111b
    
    mov ds:[986],'E'
    mov ds:[987],00000111b
    mov ds:[988],'s'
    mov ds:[989],00000111b
    mov ds:[990],'c'
    mov ds:[991],00000111b
    mov ds:[994],'-'
    mov ds:[995],00000111b
    mov ds:[998],'e'
    mov ds:[999],00000111b
    mov ds:[1000],'x'
    mov ds:[1001],00000111b
    mov ds:[1002],'i'
    mov ds:[1003],00000111b
    mov ds:[1004],'t'
    mov ds:[1005],00000111b
    
    mov ds:[1146],'E'
    mov ds:[1147],00000111b
    mov ds:[1148],'n'
    mov ds:[1149],00000111b
    mov ds:[1150],'t'
    mov ds:[1151],00000111b
    mov ds:[1152],'e'
    mov ds:[1153],00000111b
    mov ds:[1154],'r'
    mov ds:[1155],00000111b
    mov ds:[1158],'-'
    mov ds:[1159],00000111b
    mov ds:[1162],'s'
    mov ds:[1163],00000111b
    mov ds:[1164],'t'
    mov ds:[1165],00000111b
    mov ds:[1166],'a'
    mov ds:[1167],00000111b
    mov ds:[1168],'r'
    mov ds:[1169],00000111b
    mov ds:[1170],'t'
    mov ds:[1171],00000111b
    
    xor bh, bh
    mov dh, 25
    mov ah, 02
    int 10h
    
    pop ds
    pop cx
    pop bx
    pop ax
    
WaitInput4:
    call Clear
    call Pause
    
    mov ah,0
    int 16h
    cmp al,01Bh 
    je call Exit
    jne next
    ret 
    
next:       
    cmp al,0Dh
    je start
    jne WaitInput4
    
    ret
DisplayStart endp

DisplayWin proc
    mov dl,coins1
    mov dh,coins2			  		
    add dl,'0'
    add dh,'0'
    
    push ax
    push bx
    push cx
    push ds
    
    mov bx,0
    mov ah,00
    mov al,01
    int 10h
    
    mov ax, 0B800h
    mov ds, ax
    
    call DisplayCleanScreen
    
    mov ds:[514],'Y'
    mov ds:[515],00001110b
    mov ds:[516],'O'
    mov ds:[517],00001110b
    mov ds:[518],'U'
    mov ds:[519],00001110b
    mov ds:[522],'W'
    mov ds:[523],00001110b
    mov ds:[524],'I'
    mov ds:[525],00001110b
    mov ds:[526],'N'
    mov ds:[527],00001110b
    
    mov ds:[1146],'E'
    mov ds:[1147],00000111b
    mov ds:[1148],'n'
    mov ds:[1149],00000111b
    mov ds:[1150],'t'
    mov ds:[1151],00000111b
    mov ds:[1152],'e'
    mov ds:[1153],00000111b
    mov ds:[1154],'r'
    mov ds:[1155],00000111b
    mov ds:[1158],'-'
    mov ds:[1159],00000111b
    mov ds:[1162],'s'
    mov ds:[1163],00000111b
    mov ds:[1164],'t'
    mov ds:[1165],00000111b
    mov ds:[1166],'a'
    mov ds:[1167],00000111b
    mov ds:[1168],'r'
    mov ds:[1169],00000111b
    mov ds:[1170],'t'
    mov ds:[1171],00000111b
    
    mov ds:[986],'C'
    mov ds:[987],00001111b
    mov ds:[988],'o'
    mov ds:[989],00001111b
    mov ds:[990],'i'
    mov ds:[991],00001111b
    mov ds:[992],'n'
    mov ds:[993],00001111b
    mov ds:[994],'s'
    mov ds:[995],00001111b
    mov ds:[996],':'
    mov ds:[997],00001111b
    
    mov ds:[1000],dl
	mov ds:[1001],00001111b
	mov ds:[1002],dh
	mov ds:[1003],00001111b 
	
	xor bh, bh
    mov dh, 25
    mov ah, 02
    int 10h
    
    pop ds
    pop cx
    pop bx
    pop ax
    
WaitInput3:
    mov ah,0
    int 16h    
    cmp al,0Dh
    jne WaitInput3
    je start
    
    ret
DisplayWin endp

DisplayLose proc
    push ax
    push bx
    push cx
    push ds
    
    mov bx,0
    mov ah,00
    mov al,01
    int 10h
    
    mov ax, 0B800h
    mov ds, ax
    
    call DisplayCleanScreen
    
    mov ds:[510],'Y'
    mov ds:[511],00001100b
    mov ds:[512],'O'
    mov ds:[513],00001100b
    mov ds:[514],'U'
    mov ds:[515],00001100b
    mov ds:[518],'L'
    mov ds:[519],00001100b
    mov ds:[520],'O'
    mov ds:[521],00001100b
    mov ds:[522],'S'
    mov ds:[523],00001100b
    mov ds:[524],'E'
    mov ds:[525],00001100b
    
    mov ds:[1146],'E'
    mov ds:[1147],00000111b
    mov ds:[1148],'n'
    mov ds:[1149],00000111b
    mov ds:[1150],'t'
    mov ds:[1151],00000111b
    mov ds:[1152],'e'
    mov ds:[1153],00000111b
    mov ds:[1154],'r'
    mov ds:[1155],00000111b
    mov ds:[1158],'-'
    mov ds:[1159],00000111b
    mov ds:[1162],'s'
    mov ds:[1163],00000111b
    mov ds:[1164],'t'
    mov ds:[1165],00000111b
    mov ds:[1166],'a'
    mov ds:[1167],00000111b
    mov ds:[1168],'r'
    mov ds:[1169],00000111b
    mov ds:[1170],'t'
    mov ds:[1171],00000111b
    
    xor bh, bh
    mov dh, 25
    mov ah, 02
    int 10h
    
    pop ds
    pop cx
    pop bx
    pop ax
    
WaitInput2:
    mov ah,0
    int 16h    
    cmp al,0Dh
    jne WaitInput2
    je start
        
    ret
DisplayLose endp

DisplayLevel proc
    xor bh, bh
    mov dh, 25
    mov ah, 02
    int 10h
       
    mov bx,0
    mov ah,00
    mov al,01
    int 10h 
    
    mov ax,0B800h
    mov es,ax
    mov di,0
        
    mov si,offset level
    add si,LevelPosition
    sub si,2
    mov cx,2000
    mov bx,0 
    mov ax,81
    
Output:
    cmp bx,ax
    je Increment                         
    inc bx
    movsb   
loop Output
    ret

Increment:
    add si,140
    add bx,2
    add ax,82
    jmp Output

    ret
DisplayLevel endp

DisplayMario proc
    push ax
    push bx
    push cx
    push ds
      
    call MarioPosition
    mov ax, 0B800h
    mov ds, ax         
    
    mov byte ptr[bx],01111111b
    sub bx,80
    mov byte ptr[bx],01000100b
    add bx,160
    mov byte ptr[bx],00010001b
    
    xor bh, bh
    mov dh, 25
    mov ah, 02
    int 10h
    
    pop ds
    pop cx
    pop bx
    pop ax
     
    ret
DisplayMario endp 

DisplayMobs proc
    mov bx,offset level    ;mobe1
    mov ax,yMobe1
    mov cl,220
    mul cl
    add ax,xMobe1
    mov si,ax 
    mov ah,Mobe1
    mov [bx+si],ah
    
    mov bx,offset level    ;mobe2
    mov ax,yMobe2
    mov cl,220
    mul cl
    add ax,xMobe2
    mov si,ax
    mov ah,Mobe2
    mov [bx+si],ah
    
    mov bx,offset level    ;mobe3
    mov ax,yMobe3
    mov cl,220
    mul cl
    add ax,xMobe3
    mov si,ax
    mov ah,Mobe3
    mov [bx+si],ah
    
    mov bx,offset level    ;mobe4
    mov ax,yMobe4
    mov cl,220
    mul cl
    add ax,xMobe4
    mov si,ax
    mov ah,Mobe4
    mov [bx+si],ah
    
    mov bx,offset level    ;mobe5
    mov ax,yMobe5
    mov cl,220
    mul cl
    add ax,xMobe5
    mov si,ax
    mov ah,Mobe5
    mov [bx+si],ah
    
    mov bx,offset level    ;mobe6
    mov ax,yMobe6
    mov cl,220
    mul cl
    add ax,xMobe6
    mov si,ax 
    mov ah,Mobe6
    mov [bx+si],ah
    
    xor bh, bh
    mov dh, 25
    mov ah, 02
    int 10h 
    
    ret
DisplayMobs endp

DisplayLifes proc
    mov dl,lifes			  		
    add dl,'0'
    
    push ax
    push bx
    push cx
    push ds 
    
    cmp lifes,1
    jne notDisplay
    
Display:
    mov ax, 0B800h
    mov ds, ax
    
    mov ds:[56],03
    mov ds:[57],00110101b
    
notDisplay:
    pop ds
    pop cx
    pop bx
    pop ax
    ret
DisplayLifes endp

DisplayCoins proc
    mov dl,coins1
    mov dh,coins2			  		
    add dl,'0'
    add dh,'0'
    
    push ax
    push bx
    push cx
    push ds
    
    mov ax, 0B800h
    mov ds, ax
    
    mov ds:[62], 'C'
    mov ds:[63],  00110001b     ;1 mig, 2-4 fon, 5 mig, 6-8 simvol 
    mov ds:[64], 'o'
	mov ds:[65],  00110001b
    mov ds:[66], 'i'
	mov ds:[67],  00110001b
    mov ds:[68], 'n'
	mov ds:[69],  00110001b
    mov ds:[70], 's'
	mov ds:[71],  00110001b
    mov ds:[72], ':'
	mov ds:[73],  00110001b 
    
    mov ds:[74],dl
	mov ds:[75],00110001b
	mov ds:[76],dh
	mov ds:[77],00110001b 
	
	xor bh, bh
    mov dh, 25
    mov ah, 02
    int 10h
	
	pop ds
    pop cx
    pop bx
    pop ax
    ret
DisplayCoins endp

MarioPosition proc
    mov bx, offset MarioPositionY
    mov ax, [bx]
    mov cl, 80                   
    mul cl                      
    mov bx, offset MarioPositionX
    mov cx, [bx]
    add ax, cx
    mov bx, ax
    inc bx 
    ret
MarioPosition endp

MarioPositionInLevel proc
    mov bx, offset MarioPositionY
    mov ax, [bx]
    mov cl, 220                   
    mul cl                      
    mov bx, offset MarioPositionX
    mov cx, [bx]
    add ax, cx
    mov bx, offset levelPosition
    mov cx, [bx]   
    add ax, cx
    sub ax,2
    mov bx, ax
    inc bx
    ret 
MarioPositionInLevel endp

MoveMobs proc
    cmp mobePosition,0
    je toRight
    cmp mobePosition,10
    je toLeft
    jmp Contin5
toLeft:
    mov mobeMovement,-2
    jmp Contin5
toRight:
    mov mobeMovement,2

Contin5:    
    mov bx,offset level   ;mobe1
    mov ax,yMobe1
    mov cl,220
    mul cl
    add ax,xMobe1
    mov si,ax
    mov [bx+si],0BBh
    mov ax,mobeMovement 
    
    mov bx,offset level   ;mobe2
    mov ax,yMobe2
    mov cl,220
    mul cl
    add ax,xMobe2
    mov si,ax
    mov [bx+si],0BBh
    mov ax,mobeMovement 
    
    mov bx,offset level   ;mobe3
    mov ax,yMobe3
    mov cl,220
    mul cl
    add ax,xMobe3
    mov si,ax
    mov [bx+si],0BBh
    mov ax,mobeMovement 
    
    mov bx,offset level   ;mobe4
    mov ax,yMobe4
    mov cl,220
    mul cl
    add ax,xMobe4
    mov si,ax
    mov [bx+si],0BBh
    mov ax,mobeMovement 
    
    mov bx,offset level   ;mobe5
    mov ax,yMobe5
    mov cl,220
    mul cl
    add ax,xMobe5
    mov si,ax
    mov [bx+si],0BBh
    mov ax,mobeMovement 
    
    mov bx,offset level   ;mobe6
    mov ax,yMobe6
    mov cl,220
    mul cl
    add ax,xMobe6
    mov si,ax
    mov [bx+si],0BBh
    mov ax,mobeMovement
    
    add xMobe1,ax
    add xMobe2,ax
    add xMobe3,ax
    add xMobe4,ax
    add xMobe5,ax
    add xMobe6,ax
    add mobePosition,ax
    
    ret
MoveMobs endp

MoveMario proc
    call MarioPosition
    cmp xMovement,0
    jl call MoveLeft
    jg call MoveRight
    cmp yMovement,-1
    je Jump
    jne NotMove
     
Jump:
    push dx
    call MoveUp
    
    call Pause
    
    mov ah,1
    int 16h
    cmp al,'d'         
    jne next1
    add xMovement,1 
    
next1:
    cmp al,'a'         
    jne next2
    sub xMovement,1    
    
next2:
    cmp al,01Bh
    je start
    
    call Clear
        
    pop dx
    dec dx
    cmp dx,0
jne loop Jump
    
    cmp xMovement,0
    jg call MoveRight
    jl call MoveLeft
    
Fall: 
    call MoveDown
    call MarioPositionInLevel 
    cmp [bx+440],0BBh         
    je Fall
    cmp [bx+439],'$'
    je Fall
    cmp [bx+440],0CCh         
    je Fall
    cmp [bx+439],03
    je Fall
    cmp [bx+439],01
    je Fall

    jmp NotMove
    
NotMove:
    call MoveMobs
    call DisplayMobs
    mov yMovement,0
    mov xMovement,0
    
    call MarioPositionInLevel
    
    cmp [bx-220],0CCh
    je haveLifes
    cmp [bx],0CCh
    je haveLifes
    cmp [bx+220],0CCh
    je haveLifes
    ret
    
haveLifes:
    cmp lifes,1
    jne call DisplayLose  
    mov lifes,0                           
    ret
MoveMario endp

MoveUp proc
    call Pause  
    
    call MarioPositionInLevel
    cmp [bx-440],0BBh
    jne isBonus
    jmp endUp
    
isBonus:
    cmp [bx-440],06Fh
    jne NotMove4
    mov [bx-440],066h
    cmp bonusCounter,1
    jle NotMove
    
    cmp bonusCounter,2
    je givMoney
    cmp bonusCounter,3
    je givMoney            
    
    cmp bonusCounter,4
    je givArmor
    cmp bonusCounter,5 
    je givArmor 
    
givMoney:
    mov [bx-661],01 ;smile
    mov [bx-660],03Dh
    jmp NotMove
    
givArmor:
    mov [bx-661],03 
    mov [bx-660],03Dh
    jmp NotMove
        
endUp:    
    sub MarioPositionY,1
    call DisplayLevel
    call DisplayMario
    call DisplayCoins
    call DisplayLifes
  
NotMove4:    
    ret
MoveUp endp

MoveLeft proc
    call MarioPositionInLevel
    cmp [bx+217],03
    je AddLife1
    cmp [bx+217],01
    je AddMoney1                   
    cmp [bx+218],066h        
    je NotMove3
    cmp [bx-2],066h         
    je NotMove3
    cmp [bx-222],066h        
    je NotMove3
    cmp [bx+218],0AAh        
    je NotMove3
    cmp [bx-2],0AAh         
    je NotMove3
    cmp [bx-222],0AAh        
    je NotMove3  
    
    cmp [bx-222],0CCh
    je haveLifes1
    cmp [bx-2],0CCh
    je haveLifes1
    cmp [bx+218],0CCh
    je haveLifes1

    cmp [bx+217],'$'        
    je Contin1
    cmp [bx-3],'$'         
    je Contin1
    cmp [bx-223],'$'        
    je Contin1
    jmp Contin11
    
haveLifes1:
    cmp lifes,1
    jne call DisplayLose  ;
    mov lifes,0
    jmp Contin11
    
AddMoney1:
    add coins1,1
    mov [bx+217],' '
    mov [bx+218],0BBh
    jmp Contin11
    
AddLife1:
    mov lifes,1
    mov [bx+217],' '
    mov [bx+218],0BBh
    jmp Contin11

Contin1:
    call TakeCoin
    mov [bx+217],' '
    mov [bx+218],0BBh
    mov [bx-3],' '
    mov [bx-2],0BBh
    mov [bx-223],' '
    mov [bx-222],0BBh
    
Contin11:
    
    cmp MarioPositionX,24
    jge Move1 
    cmp LevelPosition,4
    jl Move1    
    sub LevelPosition,2
    jmp Continue2

Move1:
    cmp MarioPositionX,0
    jbe Continue
    sub MarioPositionX,2

Continue2:    
    call DisplayLevel
    call DisplayMario
    call DisplayCoins
    call DisplayLifes 
    
    call Pause
    
    add xMovement,1
    cmp xMovement,0
jl call MoveLeft
    
NotMove3:    
    jmp Fall
    ret
MoveLeft endp 

TakeCoin proc
    add coins2,1
    cmp coins2,10
    jne taken
    mov coins2,0
    add coins1,1
    
taken:
    ret
TakeCoin endp

MoveRight proc
    call MarioPositionInLevel
    cmp [bx+221],03
    je AddLife2
    cmp [bx+221],01
    je AddMoney2
    cmp [bx+222],066h
    je NotMove1
    cmp [bx+2],066h
    je NotMove1
    cmp [bx-218],066h
    je NotMove1
    cmp [bx+222],0AAh
    je NotMove1
    cmp [bx+2],0AAh
    je NotMove1
    cmp [bx-218],0AAh
    je NotMove1
    
    cmp [bx-218],0CCh
    je haveLifes2
    cmp [bx+2],0CCh
    je haveLifes2
    cmp [bx+222],0CCh
    je haveLifes2

    cmp [bx+221],'$'        
    je Contin2
    cmp [bx+1],'$'         
    je Contin2
    cmp [bx-219],'$'        
    je Contin2
    jmp Contin22
    
haveLifes2:
    cmp lifes,1
    jne call DisplayLose  
    mov lifes,0
    jmp Contin22
    
AddMoney2:
    add coins1,1
    mov [bx+221],' '
    mov [bx+222],0BBh
    jmp Contin22
    
AddLife2:
    mov lifes,1
    mov [bx+221],' '
    mov [bx+222],0BBh
    jmp Contin22
    
Contin2:
    call TakeCoin
    mov [bx+221],' '
    mov [bx+222],0BBh
    mov [bx+1],' '
    mov [bx+2],0BBh
    mov [bx-219],' '
    mov [bx-218],0BBh
    
Contin22:    
    
    cmp MarioPositionX,50
    jbe Move2 
    cmp LevelPosition,140
    jg Move2    
    add LevelPosition,2
    jmp Continue

Move2:
    cmp MarioPositionX,78
    jge Continue
    add MarioPositionX,2    
    
Continue:
    call DisplayLevel
    call DisplayMario
    call DisplayCoins
    call DisplayLifes
    
    call Pause 
    
    cmp MarioPositionX,76
    jge call DisplayWin 
    
    sub xMovement,1
    cmp xMovement,0
    jg call MoveRight
    
NotMove1:
    jmp Fall
    ret
MoveRight endp

MoveDown proc
    call Pause
    
    call MarioPositioninLevel
    cmp [bx+439],03
    je AddLife3
    cmp [bx+439],01
    je AddMoney3
    cmp [bx+440],0CCh 
    je KillMobe
    jne NotMobe
    
KillMobe:
    mov ax,MarioPositionX
    sub ax,1
    add ax,levelPosition
    cmp xMobe1,ax
    je  mb1
    cmp xMobe2,ax
    je  mb2                                
    cmp xMobe3,ax
    je  mb3
    cmp xMobe4,ax
    je  mb4
    cmp xMobe5,ax
    je  mb5
    cmp xMobe6,ax
    je  mb6
    jmp NotMobe 
mb1: 
    mov Mobe1,0BBh
    jmp NotMobe
mb2:
    mov Mobe2,0BBh
    jmp NotMobe
mb3: 
    mov Mobe3,0BBh
    jmp NotMobe
mb4:
    mov Mobe4,0BBh
    jmp NotMobe
mb5:
    mov Mobe5,0BBh
    jmp NotMobe
mb6:
    mov Mobe6,0BBh             
    
NotMobe:
    call DisplayMobs 
    call MarioPositionInLevel  
    cmp [bx+440],0BBh         
    jne Money3
    jmp Contin333
    
Money3:
    cmp [bx+439],'$'
    je Contin3
    jne Contin33
    
AddMoney3:
    add coins1,1
    mov [bx+439],' '
    mov [bx+440],0BBh
    jmp Contin333
    
AddLife3:
    mov lifes,1
    mov [bx+439],' '
    mov [bx+440],0BBh
    jmp Contin333
    
Contin3:
    call TakeCoin
    mov [bx+439],' '
    mov [bx+440],0BBh
    jmp Contin333

Contin33:
    cmp [bx+440],0CCh
    jne NotMove2
    
Contin333:     
    add MarioPositionY,1  
    
NotMove2: 
    call DisplayMobs   
    call DisplayLevel
    call DisplayMario
    call DisplayCoins
    call DisplayLifes
     
    cmp MarioPositionY,23
    je call DisplayLose
                                             
    ret
MoveDown endp

Pause proc 
    
    push si
    
    mov si,1
    mov ah,0
    int 1Ah
    
    mov bx,dx
    add bx,si
Stay:    
    int 1Ah
    cmp dx,bx
    jne Stay
    pop si
    ret
Pause endp

Clear proc
    cli                  
    sub  AX,AX           
    mov  ES,AX            
    mov  AL,ES:[41AH]     
    mov  ES:[41CH],AL     
    sti
    ret
Clear endp

main:    
    mov ax,@data
    mov ds,ax
    
    mov cx,5500
    mov si,0

copy: 
    mov bx,offset level
    mov ah,[bx+si]
    mov bx,offset baseLevel
    mov [bx+si],ah
    inc si
loop copy 

    call DisplayStart
       
start:     
    mov cx,5500
    mov si,0
    
    mov Mobe1,0CCh
    mov Mobe2,0CCh
    mov Mobe3,0CCh
    mov Mobe4,0CCh
    mov Mobe5,0CCh
    mov Mobe6,0CCh
    mov lifes,0

copy2: 
    mov bx,offset baseLevel
    mov ah,[bx+si]
    mov bx,offset level
    mov [bx+si],ah
    inc si
    loop copy2   
    
    mov MarioPositionX,2
    mov MarioPositionY,22
    mov LevelPosition,2
    mov coins1,0
    mov coins2,0 
            
    call DisplayMobs        
    call DisplayLevel
    call DisplayMario
    call DisplayCoins
    call DisplayLifes
    jmp WaitInput

RightEntered:
    mov xMovement,1
    call MoveMario
    jmp WaitInput
    
LeftEntered:
    mov xMovement,-1
    call MoveMario
    jmp WaitInput
    
UpEntered:
    call Clear
    mov yMovement,-1
    mov dx,6
    call MoveMario
    jmp WaitInput
    
DownEntered:
    mov yMovement,1
    call MoveMario
    jmp WaitInput
    
WaitInput:
    call Clear
    
    call Pause
    
    add bonusCounter,1
    cmp bonusCounter,5 
    je ClearBonusCounter
    jmp NotClear 
    
ClearBonusCounter:
    mov bonusCounter,0
    
NotClear:
    mov ah,1
    int 16h
    cmp al,'d'         ;4Dh
    je RightEntered
    cmp al,'a'         ;4Bh
    je LeftEntered
     
    cmp al,' '         ;48h
    je UpEntered
    
    cmp al,01Bh
    je call DisplayStart
    
jmp WaitInput

Exit proc
    mov ax,4C00h
    int 21h
Exit endp

end main