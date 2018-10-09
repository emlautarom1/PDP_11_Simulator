⍝ Start PDP11, Pc←1050
initiate11
sintax11
ind[Spec, Invop]←0
7 regin(word magnr 1050)

⍝ @Test: ADD - inmediate
∇ test_add_inmediate
    ⍝ Load instrucction
    (word, memadr, regout Pc) write11 0 1 1 0 0 1 0 1 1 1 0 0 0 0 0 0
    ⍝ Set Reg0 with B, ex ¯1
    0 regin (word radixcompr ¯1)
    ⍝ Set inmediate value A, ex 5
    (word, memadr, 2 + regout Pc) write11 (word radixcompr 5)
    ⍝ Load and execute instrucction from Pc
    inst←ifetch11
    execute inst
    ⍝ Assert equals
    4 = magni regout 0
∇

⍝ @Test: ADD - index + displacement
∇ test_add_index_displ
    ⍝ Load instrucction
    (word, memadr, regout PC) write11 0 1 1 0 0 0 0 0 0 0 1 1 0 0 0 0
    ⍝ Set index as inmediate
    (word, memadr, 2 + regout Pc) write11 (word radixcompr 1020)
    ⍝ Set Reg0 with displacement, ex 4
    0 regin (word radixcompr 4)
    ⍝ Set memadr with operand, ex 5
    (word, memadr, 1024) write11 (word radixcompr 5)
    ⍝ Load and execute instrucction from Pc
    inst←ifetch11
    execute inst
    ⍝ Assert equals
    9 = magni read11 (word, memadr, 1024)
∇