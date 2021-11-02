program Bubble;

{$APPTYPE CONSOLE}

procedure bolha; assembler;
  asm
    push esi

    shl eax, 2
    add eax, ebp   // 4*10 + v
    mov ebx, eax
    sub eax, 4     // 4*9 + v
    mov ecx, ebp   // for i := 0 + v
  @fori_loop:
    cmp ecx, eax   // i < 4*9 + v
    jz @fori_close

    mov edx, ecx
    add edx, 4     // for j := i + 4 + v
  @forj_loop:
    cmp edx, ebx   // j < 4*10 + v
    jz @forj_close

    mov esi, [ecx]
    cmp esi, [edx]
    jle @fim_troca

    mov edi, [edx] // if maior then trocar
    mov [ecx], edi
    mov [edx], esi

  @fim_troca:
    add edx, 4     // j++
    jmp @forj_loop

  @forj_close:
    add ecx, 4     // i++
    jmp @fori_loop
  @fori_close:
    pop esi
  end;

var
  v: array[0..999] of integer;
  i: integer;
begin
  for i := 0 to 665 do
    v[i] := 666 - 2*i;
  for i := 666 to 999 do
    v[i] := 0;
  i := integer(@v);
  asm
    mov ebp, [i];
    mov eax, 1000
  end;
  bolha;
  for i := 0 to 999 do
    write(v[i], ' ');
end.

Fora da caridade não há salvação. Com caridade, há evolução.
Vinícius Claudino Ferraz, 2020/Aug/21
