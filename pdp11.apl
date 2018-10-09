⍝ index origin
⎕IO←0

⍝----------------------
⍝ control structures --
⍝----------------------

P_i_l_a←⍳1

∇label←IF cond
label←(ELSE,THEN)[cond]
∇

∇label←If cond
label←(ENDIF,THEN)[cond]
∇

∇label←UNTIL cond
label←(~ cond)/REPEAT
∇

∇label←WHILE cond
label←(~cond)/ENDWHILE
P_i_l_a←(cond/⎕LC[1]),P_i_l_a
∇

∇label←LOOP
label←1↑P_i_l_a
P_i_l_a←1↓P_i_l_a
∇

∇label←CASE num
label←⍎'C',⍕num
∇

∇label←OUT cond
label←cond/0
∇

∇label←ERROR cond
label←cond/0
∇

⍝ error report
∇which report cond
⍝ set indicator if cond is true
ind[which]←∨/ind[which],cond
∇

∇i
⍝ invalid operation
Invop report 1
∇

⍝--------------------------
⍝ manipulation functions --
⍝--------------------------

∇lista← l append e;s;long
→IF (⍴⍴l)≤1
THEN: lista←l,e
→ENDIF
ELSE:
s←1↓⍴l
long←1↑⍴l
lista←((long+1),s)⍴(,l),e
ENDIF:
∇

⍝-----------------------------------------------
⍝ representation and interpretation functions --
⍝-----------------------------------------------

∇value←magni rep
⍝ interpretacion de magnitud
⍝value←radix⊥⍉rep
m1←⌊(0⊥¯1↑⍴rep)÷2
m2←⌈(0⊥¯1↑⍴rep)÷2
v1←radix⊥⍉ ((((⍴⍴rep)-1)⍴0), m2)↓rep
v2←radix⊥⍉ ((¯1↓(⍴rep)), m2)↑rep
value←(v2×radix*m1)+v1
∇

∇number←magn0i rep;modulus;value
⍝ interpretacion de magnitud high zero
modulus←radix*0⊥¯1↑⍴rep
⍝value←radix⊥⍉rep
value←magni rep
number←value+modulus×value=0
∇

∇number←signmagni rep;modulus;value;m1;m2
⍝ interpretacion signo magnitud
m1←radix*⌊((0⊥¯1↑⍴rep)-1)÷2
m2←radix*⌈((0⊥¯1↑⍴rep)-1)÷2
modulus←m1×m2
value←radix⊥⍉rep 
number←(1, ¯1)[(⌊value÷modulus)∊1⍴minus]×((m1|⌊value÷m2)×m2)+m2|value
∇

∇number←radixcompi rep;value;m1;m2;v1;v2
⍝ interpretacion complemento a la raiz
m1←⌊(0⊥¯1↑⍴rep)÷2
m2←⌈(0⊥¯1↑⍴rep)÷2
v1←radix⊥⍉ ((((⍴⍴rep)-1)⍴0), m2)↓rep
v2←radix⊥⍉ ((¯1↓(⍴rep)), m2)↑rep
value←(v2×radix*m1)+v1
number←value-(value≥(radix*m2)×(radix*m1-1))×(radix*m2)×(radix*m1)
∇

∇number←digitcompi rep;modulus;value
⍝ interpretacion complemento a la raiz disminuida
⍝modulus←(radix*0⊥¯1↑⍴rep)-1
⍝value←radix⊥⍉rep
⍝number←value-(value≥modulus÷2)×modulus
value←radixcompi rep
number← value+(0,1)[value<0]
∇

∇rep←size magnr value
⍝ representacion de magnitud
rep←⍉(size⍴radix)⊤value
∇

∇rep←size signmagnr number;modulus;sign
⍝ representacion signo magnitud
modulus←radix*size-1
sign←((1↑plus),minus)[number<0]
rep←sign,⍉((size-1)⍴radix)⊤|number
∇

∇rep←size radixcompr number;modulus
⍝ representacion signo magnitud
modulus←radix*size
rep←⍉(size⍴radix)⊤number
⍝ domain signals
xmax←number≥modulus÷2
xmin←number<-modulus÷2
∇

∇rep←size digitcompr number;modulus
⍝ representacion raiz disminuida
modulus←(radix*size)-1
rep←⍉(size⍴radix)⊤modulus|number
⍝ domain signals
xmax←number≥modulus÷2
xmin←number<-modulus÷2
∇

⍝------------------------------
⍝-- floating-point functions --
⍝------------------------------

∇number← biasi rep;bias;value
⍝ bias interpretation
   bias←⌊0.5×radix*0⊥ ¯1↑⍴rep
   value← radix⊥⍉rep
   number←value-bias
∇

∇rep← size biasr number;bias
⍝ bias representation
   bias←⌊0.5×radix*size
   rep←⍉(size⍴radix) ⊤ number+bias
∇

∇ rep← hidebit rep
⍝ hide hidden bit
⍝ rep is signed-magnitude
   rep[1]←rep[0]
∇

∇rep←insertbit rep
⍝ expose hidden bit
⍝ rep is signed-magnitude
rep[1]←1
∇

∇ result← truncate number
⍝ truncation to zero
   result← (×number)×⌊|number
∇

∇result← round number
⍝ algebraic round
   result←(×number)×⌊0.5+|number
∇

∇ result← trueround number;bias
⍝ unbiased algebraic round
   bias ← 0.5≠2||number
   result←(×number)×⌊(0.5×bias)+|number
∇

∇ expzero normalize numexp;expnorm
⍝ normalized or specified exponent form
⍝ numexp is a vector (number,exponent)
   →IF 0=1 ↑ numexp
  THEN: ⍝ exponent for zero
     exponent← expzero
         →ENDIF
  ELSE: ⍝ minimal or speciefied exponent
     expnorm←⌊(1+base⍟|1↑numexp)+point-(⍴1↓Coef)×base⍟radix
     exponent← ⌈/expnomr,1↓numexp
  ENDIF:
   coefficient←0⊥(1↑numexp)÷base*exponent-point
∇

∇numexp← flbsi rep;exponent;coefficient;number
⍝ bias signed-magnitude fractional interpretation
   exponent←biasi rep[Exp]
   coefficient← signmagni rep[Coef]
   number← coefficient×base-point
   numexp←number,exponent
∇

∇rep← size flbsr numexp;exponent;coefficient
⍝ bias signed-magnitude fractional representation
   (1↑1↓numexp,-extexp) normalize numexp
   rep← size⍴0
   rep[Coef]←(⍴Coef) signmagnr truncate coefficient
   rep[Exp]←(⍴Exp) biasr exponent
∇
⍝-------------------------
⍝-- character functions --
⍝-------------------------

∇string←alphai rep
⍝ character string interpretation
string←charcode[magni rep]
∇

∇rep←size alphar string
⍝ character string representation
rep←size magnr charcode⍳string
∇

∇out←size wide in;dim
⍝ ajuste de ancho
dim←(⌈(⍴,in)÷size),size
⍝ extend with zero as needed
out←dim⍴(-×/dim)↑,in 
∇

∇value←fld field
⍝ instruction field decoding
value←magni inst[field]
∇

∇value←fld0 field
⍝ instruction field decoding
value←magn0i inst[field]
∇

∇carry← expmod carryfrom operands
⍝ carry in addition
carry← (radix*expmod)≤+/(radix*expmod)∘.|operands
∇

⍝-----------------------------------------------
⍝-- Machine Language Interpretation functions --
⍝-----------------------------------------------

∇r←decode inst;f;type
⍝ opcode decoding
⍝ 11 opcode 10 -x- 01 uno 00 cero
f←form[;⍳⍴inst;]
type ← +/∨\⌽1↓(((∨/f)∧.≥ inst) ∧ (</f)∧.≤ inst)
r←orop[type]+magni (∧/form[type;;])/inst
∇

∇execute inst
⍝ instruction execution
⍎ ⍕oplist[decode inst;]
∇

⍝------------------
⍝-- Architecture --
⍝------------------

∇initiate11
⍝ Iniciacion de la DEC PDP-11
format11
configure11
space11
name11
control11
⍝ data11
∇
 
∇format11
⍝ unidades de informacion de la DEC PDP-11
⍝ radix de representacion
radix←2
⍝ unidades de informacion
byte← 8
word←16
long← 32
⍝ capacidad de direccionamiento
adrcap←radix*word
∇

∇configure11
⍝ configuracion de la DEC PDP-11
⍝ capacidad de memoria
memcap←radix*word
∇

∇space11
⍝ espacios de la DEC PDP-11
⍝ memoria
memory←?(memcap , byte)⍴radix
⍝ almacenamiento de trabajo
⍝ - Registros generales
reg← ?(16,word)⍴ radix

⍝ - Registros de punto flotantes
flregs← ?(6,long)⍴radix

⍝ almacenamiento de control
⍝ -indicadores
ind← ?43⍴radix
⍝ -estatus de punto flotante
flstatus←?word⍴radix
⍝ -excepci'on de punto flotante
fle←?4⍴radix
⍝ -stop y wait
stop←?radix
wait←?radix
⍝ input/output
∇

∇name11
⍝ espacio de nombres de la DEC PDP-11
⍝ memory embedding
⍝ - estatus de programa
Psw←memcap-2
⍝ - l'imite de la pila
Slw←memcap-4
⍝ - interrupci'on programada
Piw← memcap-6
⍝ -vector de interrupciones
Intvec← 4×⍳43
⍝ nombres de registros
⍝ - puntero de pila
Sp←6
⍝ - direcci'on de instrucci'on
Pc←7
⍝ dispositivos de entrada/salida
name11io
∇

∇control11
⍝ DEC PDP-11 control allocation
instruction11
indicator11
status11
status11fl
address11
∇

∇instruction11
⍝ DEC PDP-11 instruction allocation
⍝ - especificaci'on de tama\~no
Byte←,0
⍝ operation specification
Opcode←1+⍳3
⍝ operand specification
Source←4+⍳6
Dest← 10+⍳6
Rfl← 8+⍳2
Cadr← 12+⍳4
⍝ operaciones de registros y bifurcaciones
Opb← 4+⍳3
Opf← 4+⍳4
Offset← 8+⍳8
⍝ operaciones de un solo operando
Ops← 8+⍳2
⍝ extensi'on del c'odigo de operaci'on
Ope← 13+⍳3
⍝ suballoction del campo de direcci'on
⍝ -modo
M←0+⍳3
⍝ -registro
R← 3+⍳3
∇

∇indicator11
⍝ DEC PDP-11 indicator allocation
⍝ programa
Warning← 0
Spec← 1
Invop← 2
⍝ break point
Bpt←3
⍝ input/output
Iot← 4
⍝ falla de potencia
Powerfail←5
⍝ emulador
Emt← 6
⍝ trap general
Trap← 7
⍝ interrupcion programada
Pir← 40
⍝ excepci'on de punto flotante
Fle← 41
⍝ dispositivos de entrada/salida
indicator11io
∇

⍝------------
⍝-- Sintax --
⍝------------

∇sintax11 ;mapt;typet;x;Op                  ⍝ 0=0 1=1 2=x 3=Op
⍝ form inicializada vacia
 form← 0 0 2 ⍴ 0
 mapt← 0 0 ⍴ 0
typet← 0 ⍴ 0
    x←2
   Op←3

  'Byte' insertfield x
'Opcode' insertfield Op
'Source' insertfield x
'Offset' insertfield x
  'Dest' insertfield x
   'Opf' insertfield Op
   'Opb' insertfield Op
   'Rfl' insertfield x
   'Ops' insertfield Op
  'Cadr' insertfield x
   'Ope' insertfield Op

fa Byte,Opcode,Source,Dest  
fb 0 1 1 0 ,Source,Dest 
fb 1 1 1 0 ,Source,Dest 
fc 0 1 1 1 ,Opb,Source[R],Dest  
fd 0 0 0 0 ,Opf,Offset  
fd 1 0 0 0 ,Opf,Offset  
fe 1 1 1 1 ,Opf,Rfl,Dest  
ff 0 0 0 0 1 0 0,Source[R],Dest  
fg Byte,0 0 0 1 0 1 0,Ops,Dest  
fg Byte,0 0 0 1 0 1 1,Ops,Dest  
fg Byte,0 0 0 1 1 0 0,Ops,Dest  
fh 0 0 0 0 0 0 0 0,Ops,Dest  
fh 0 0 0 0 1 1 0 1,Ops,Dest  
fh 1 1 1 1 0 0 0 0,Ops,Dest  
fh 1 1 1 1 0 0 0 1,Ops,Dest  
fi 0 0 0 0 0 0 0 0 1 0 0 0 0,Dest[R]  
fi 0 0 0 0 0 0 0 0 1 0 0 1 1,Dest[R] 
fj 0 0 0 0 0 0 0 0 1 0 1 0,Cadr  
fj 0 0 0 0 0 0 0 0 1 0 1 1,Cadr 
fk 0 0 0 0 0 0 0 0 0 0 0 0 0,Ope 
fk 1 1 1 1 0 0 0 0 0 0 0 0 0,Ope 
fk 1 1 1 1 0 0 0 0 0 0 0 0 1,Ope

orop ← ¯1↓ +\0,2*+/∧/form
oplist← 123 5⍴ "→d   MOV  CMP  BIT  BIC  BIS  →b   →ce  ADD  SUB  MUL  DIV  ASH  ASHC XOR  i    i    SOB  →h   BR   BNE  BEQ  BGE  BLT  BGT  BLE  →f   →f   →g   →g   →g   →h   i    i    BPL  BMI  BHI  BLOS BVC  BVS  BCC  BCS  EMT  TRAP →g   →g   →g   i    i    i    →h   →h   MULF MODF ADDF LDF  SUBF CMPF STF  DIVF STEX STCI STCF LDEX LDCI LDCF JSR  CLR  COM  INC  DEC  NEG  ADC  SBC  TST  ROR  ROL  ASR  ASL  →k   JMP  →ij  SWAB MARK i    i    SXT  →k   LDFS STFS STST CLRF TSTF ABSF NEGF RTS  SPL  CLCC SECC HALT WAIT RTI  BPT  IOT  RSET RTT  i    CFCC SETF SETI i    i    i    i    i    i    SETD SETL i    i    i    i    i    " 
∇

⍝ formato de instrucci'on a
∇fa ptrn ;maskp;bptrn;valuep;w
maskp  ← (msk 'Byte'),(msk 'Opcode'),(msk 'Source'),(msk 'Dest')
valuep ← (typ 'Byte'),(typ 'Opcode'),(typ 'Source'),(typ 'Dest'),0 1
w←⍴maskp
bptrn← ⍉ 2 2 ⊤ valuep[ptrn + (~maskp) × w ⍴ w]
insertpattern bptrn
∇

∇fb ptrn ;maskp;bptrn;valuep;w
maskp  ← (4⍴ 0) ,(msk 'Source'),(msk 'Dest')
valuep ← (4⍴ 0) ,(typ 'Source'),(typ 'Dest'), 0 1
w←⍴maskp
bptrn← ⍉ 2 2 ⊤ valuep[ptrn + (~maskp) × w ⍴ w]
insertpattern bptrn
∇

∇fc ptrn ;maskp;bptrn;valuep;w
maskp  ← (4⍴ 0) ,(msk 'Opb'), (msk 'Source')[R],(msk 'Dest')
valuep ← (4⍴ 0) ,(typ 'Opb'), (typ 'Source')[R],(typ 'Dest'), 0 1
w←⍴maskp
bptrn← ⍉ 2 2 ⊤ valuep[ptrn + (~maskp) × w ⍴ w]
insertpattern bptrn
∇

∇fd ptrn ;maskp;bptrn;valuep;w
maskp  ← (4⍴ 0) ,(msk 'Opf'), (msk 'Offset')
valuep ← (4⍴ 0) ,(typ 'Opf'), (typ 'Offset'), 0 1
w←⍴maskp
bptrn← ⍉ 2 2 ⊤ valuep[ptrn + (~maskp) × w ⍴ w]
insertpattern bptrn
∇

∇fe ptrn ;maskp;bptrn;valuep;w
maskp  ← (4⍴ 0) ,(msk 'Opf'), (msk 'Rfl'),(msk 'Dest')
valuep ← (4⍴ 0) ,(typ 'Opf'), (typ 'Rfl'),(typ 'Dest'), 0 1
w←⍴maskp
bptrn← ⍉ 2 2 ⊤ valuep[ptrn + (~maskp) × w ⍴ w]
insertpattern bptrn
∇

∇ff ptrn ;maskp;bptrn;valuep;w
maskp  ← (7⍴ 0), (msk 'Source')[R], (msk 'Dest')
valuep ← (7⍴ 0), (typ 'Source')[R], (typ 'Dest'), 0 1
w←⍴maskp
bptrn← ⍉ 2 2 ⊤ valuep[ptrn + (~maskp) × w ⍴ w]
insertpattern bptrn
∇

∇fg ptrn ;maskp;bptrn;valuep;w
maskp  ← (msk 'Byte'), (7⍴ 0), (msk 'Ops'),(msk 'Dest')
valuep ← (typ 'Byte'), (7⍴ 0), (typ 'Ops'),(typ 'Dest'), 0 1
w←⍴maskp
bptrn← ⍉ 2 2 ⊤ valuep[ptrn + (~maskp) × w ⍴ w]
insertpattern bptrn
∇

∇fh ptrn ;maskp;bptrn;valuep;w
maskp  ←  (8⍴ 0), (msk 'Ops'),(msk 'Dest')
valuep ←  (8⍴ 0), (typ 'Ops'),(typ 'Dest'), 0 1
w←⍴maskp
bptrn← ⍉ 2 2 ⊤ valuep[ptrn + (~maskp) × w ⍴ w]
insertpattern bptrn
∇

∇fi ptrn ;maskp;bptrn;valuep;w
maskp  ←  (13⍴ 0), (msk 'Dest')[R]
valuep ←  (13⍴ 0), (typ 'Dest')[R], 0 1
w←⍴maskp
bptrn← ⍉ 2 2 ⊤ valuep[ptrn + (~maskp) × w ⍴ w]
insertpattern bptrn
∇

∇fj ptrn ;maskp;bptrn;valuep;w
maskp  ←  (12⍴ 0), (msk 'Cadr')
valuep ←  (12⍴ 0), (typ 'Cadr'), 0 1
w←⍴maskp
bptrn← ⍉ 2 2 ⊤ valuep[ptrn + (~maskp) × w ⍴ w]
insertpattern bptrn
∇

∇fk ptrn ;maskp;bptrn;valuep;w
maskp  ←  (13⍴ 0), (msk 'Ope')
valuep ←  (13⍴ 0), (typ 'Ope'), 0 1
w←⍴maskp
bptrn← ⍉ 2 2 ⊤ valuep[ptrn + (~maskp) × w ⍴ w]
insertpattern bptrn
∇

∇insertpattern ptrn ;widthf;lastp;w
w← 1↑⍴ptrn
lastp← 1↑⍴ form
widthf← 1↑1↓⍴ form

→CASE ((widthf<w),(widthf>w),(widthf=w))/0 1 2
C0: ⍝ el tama~no del pattern es mayor que los almacenados en form
   form ←((widthf ⍴ 1),(w-widthf)⍴0)\[1] form            ⍝ expande el ancho del pattern en form
   form[;widthf+⍳w-widthf;]← (lastp, (w-widthf),2) ⍴ 1 0  ⍝ rellena con 1 0 = 2
   →ENDCASE
C1: ⍝ el tama~no del pattern es menor que los almacenados en form
   ptrn ← ((w ⍴ 1), (widthf-w)⍴ 0)\[0]ptrn
   ptrn[s+⍳widthf-w;]← ((widthf-w),2) ⍴ 1 0     ⍝ rellena con 1 0 = 2
C2: ⍝ inserta el formato al final
ENDCASE: 
   form←  form ⍪ ptrn
   ⍝ form[lastp;;]←ptrn  
∇

∇name insertfield type ;w;lastm;l
    w← ¯1↑⍴mapt
    l← ⍴name
lastm← 1↑⍴ mapt
→CASE ((w<l),(w>l),(w=l))/0 1 2
C0: ⍝ la longitud del nombre es mayor que los almacenados en mapt
   mapt ←((w ⍴ 1),(l-w)⍴0)\[1] mapt                   ⍝ expande el ancho de los nombres
   →ENDCASE
C1: ⍝ la longitud del nombre es menor que los almacenados en mapt
   name ← ((l ⍴ 1), (w-l)⍴ 0)\name
C2: ⍝ inserta el nombre al final
ENDCASE: 
   mapt←  mapt ⍪ 0
   mapt[lastm;]←name
   typet← typet ⍪ type  
∇

∇ type ← typ name;w;l
  w←¯1↑⍴ mapt
  l← ⍴ ⍎ name
  name←name,(w-⍴name)⍴ ' '
  type← l ⍴ typet[(mapt ∧.= ⍉ name) ⍳ 1]
∇

∇mask← msk name
 mask← (⍴⍎name)⍴ 1
∇

⍝-------------------
⍝-- Status format --
⍝-------------------

∇status11
⍝ estatus de la DEC PDP-11
⍝ control de modo
Currentmode← 0+⍳2
Previousmode← 2+⍳2
⍝ Conjunto de resgistros
Regset← 4
⍝ prioridad de interrupci'on
Priority← 8+⍳3
⍝ modo trace
Trace← 11
⍝ conditiones
Neg← 12
Zero← 13
Oflo← 14
Carry← 15
⍝ codificaci'on del modo
Kernel← 0
Supervisor← 1
User← 2
∇

∇status11fl
⍝ estatus de punto flotante de la DEC PDP-11
⍝ error
Fer← 0
⍝ deshabilitaci'on de interrupci'on
Fid← 1
⍝ variable indefinida
Fiuv← 4
⍝ underflow
Fiu← 5
⍝ overflow
Fiv← 6
⍝ error de conversi'on
Fic← 7
⍝ modo double
Fd← 8
⍝ modo long integer
Fl← 9
⍝ modo truncaci'on
Ft← 10
⍝ Condiciones
Neg← 12
Zero← 13
Oflo← 14
Carry← 15
⍝ c'odigos de error
flinvop← 2
fldivide← 4
flconverr← 6
floflo← 8
fluflo← 10
flundef← 12
flmaint← 14
∇

∇  status ← stout id;psw
⍝ DEC PDP11 read program status
psw← read11 word,memadr,Psw
status← psw[id]
∇

∇  id stin status;psw
⍝ DEC PDP11 write program status
psw← read11 word,memadr,Psw
psw[id]←status
(word,memadr,Psw) write11 psw
∇

⍝---------------------------------
⍝-- Addressing in the DEC-PDP11 --
⍝---------------------------------

∇data←read11 address;size;location
⍝ PDP11 read de registro, registropf o memoria
	size←address[Size]
	→CASE address[Space]
	⍝ Branch acorde al espacio de trabajo
	C0: ⍝ Registro
		location←regmap11 address[Value]
		data←(-size⌊word)↑reg[location;]
		⍝ Se toman el minimo entre size y word bytes del registro
		→ENDCASE

	C1: ⍝ Registro PF
		data←size↑flreg[6|address[Value];]
		⍝ Se toman size bits del registro de pf especificado en Value
		flinvop report11fl address[Value]≥6
		⍝ Reporte de flags

		→ENDCASE

	C2: ⍝ Memoria
		location←address[Value]+adrperm11 size
		⍝ adrpem11 hace una permutacion
		adrcheck11 location
		⍝ verificacion de ubicacion valida
		data←,memory[memcap|location;]
		⍝ se recuperan los bits de la memoria especificados en location, con modulo memcap.
	ENDCASE:
	⍝ Por que usar +adrperm11 size ?
	⍝ Regmap11 hace ?
∇

∇address write11 data;size;location
⍝ DEC PDP11 write de registro, registropf o memoria
	size←address[Size]
	→CASE address[Space]
	C0: ⍝ Write en registro
		location←regmap11 address[Value]
		reg[location;(-size)↑⍳word]←data
		⍝ Se escriben word bits en el registro indicado
		⍝ En caso de que size sea menor que word, se escriben los ultimos size bits de data
	→ENDCASE

	C1: ⍝ Write en registro pf
		flinvop report11fl address[Value]≥6
		→OUT address[Value]≥6
		flreg[address[Value];⍳size]←data
		⍝ Se escriben los size bits en el registro indicado
	→ENDCASE

	C2: ⍝ Write en memoria
		location←address[Value]+adrperm11 size
		adrcheck11 location
		→OUT suppress11
		memory[location;]←byte wide data
	ENDCASE:
	⍝ Por que sale cuando el registro pf no es valido, pero cuando es registro comun opera igual?
	⍝ Funcion suppress11?
∇

∇perm← adrperm11 size;loc
⍝ permutaci'on de direcci'on
loc← ⍳size÷byte
perm← (⍴loc)↑,⌽2 wide loc
∇

⍝---------------------------
⍝-- Address Modification  --
⍝---------------------------

⍝ Ejecutar antes la allocation
∇address11
⍝ Attributes
   Size←0
   Space←1
   Value←2
⍝ spaces name ?
   regadr←0
   flregadr←1
   memadr←2
∇

∇address← size adr11 field ;r;step;rf
⍝ adrress from M R
r← fld field[R]
step←(size,word)[r∊ Sp,Pc]
→CASE fld field[M]
C0: ⍝ register
   address←size,regadr,r
   → ENDCASE
C1: ⍝ register indirect
   rf← magni read11 word,regadr,r
   address← size,memadr,rf
   → ENDCASE
C2: ⍝ postincrement
    address←size,1↓ step incr11 r
    → ENDCASE
C3: ⍝ postincrement indirect
    rf← magni read11 word incr11 r
    address← size,memadr,rf
    →ENDCASE
C4: ⍝ predecrement
    address←size,1↓ step decr11 r
    → ENDCASE
C5: ⍝ predecrement indirect
    rf← magni read11 word decr11 r
    address← size,memadr,rf
    →ENDCASE
C6: ⍝ index+displacement
    address←size disp11 r
C7: ⍝ index+displacement indirect
    rf← magni read11 word disp11 r
    address size,memadr,rf
ENDCASE:
∇

∇ address←size adr11fl field;r;step;rf
⍝ DEC PDP11 floating-point address
	r←fld field[R]
	step←(size,word)[r=Pc]
	→CASE fld field[M]
	C0: ⍝ register
		address←size,flregadr,r
		→ENDCASE
	C1: ⍝ register indirect
		rf←magni read11 word,regadr,r
		address←size,memadr,rf
		→ENDCASE
	C2: ⍝ postincrement
		address←step incr11 r
		→ENDCASE
	C3: ⍝ postincrement indirect
		rf←magni read11 word incr11 r
		address←size,memadr,rf
		→ENDCASE
	C4: ⍝ predecrement
		address←step decr11 r
		→ENDCASE
	C5: ⍝ predecrement indirect
		rf←magni read11 word decr11 r
		address←size,memadr,rf
		→ENDCASE
	C6: ⍝ index+displacement
		address←size disp11 r
		→ENDCASE
	C7: ⍝ index+displacement indirect
		rf← magni read11 word disp11 r
		address←size,memadr,rf
	ENDCASE:
∇

∇address←size disp11 r;index;displacement
	⍝ DEC PDP11 index plus displacement
	displacement←magni ifetch11
	index←magni regout r
	address←size,memadr,adrcap|index+displacement
∇

∇address←size incr11 r;count
	⍝ DEC PDP11 postincrement
	address←size,memadr,magni regout r
	count←address[Value]+size÷byte
	r regin word magnr count
∇

∇address←size decr11 r;count
	⍝ DEC PDP11 predecrement
	count←(magni regour r)-size÷byte
	Warning report(r=Sp)∧count=limit11
	Spec report(r=Sp)∧count=limit11-16
	address←size,memadr,adrcap|count
	r regin word magnr address[Value]
∇

∇ out ← limit11
⍝ DEC PDP11 stack limit
   → IF Kernel=magni stout Currentmode
  THEN: ⍝ kernel limit
     out← magni read11 word,memadr,Slw
    → ENDIF
  ELSE: ⍝ user and supervisor limit
     out←256
  ENDIF:
∇

∇ adr regin data
⍝ DEC PDP11 register input
reg[regmap11 adr;]← data
∇

∇ data← regout adr
⍝ DEC PDP11 register output
data← reg[regmap11 adr;]
∇

∇odd← odd11 adr
⍝ DEC PDP11 odd address
   odd← adr+0=2|adr
∇

∇ loc ← regmap11 adr 
⍝ DEC PDPll register addresses
→ CASE (adr < Sp,Pc ) ⍳ 1
C0: ⍝ register set
    loc ← adr + 8 × stout Regset
       → ENDCASE
C1: ⍝ stack pointer
    loc← Sp + (0,8,9) [magni stout Currentmode]
        → ENDCASE
C2: ⍝ instruction address
    loc ← Pc
    ENDCASE:
∇

⍝------------------------
⍝-- size specification -- 
⍝------------------------

∇ size← size11 
⍝ DEC PDP11 operand size
  size←(word,byte)[fld Byte]
∇

∇ size← size11fl
⍝ DEC PDP11 floating-point size
   size←(long,double)[flstatus[Fd]]
∇

⍝----------------------
⍝-- Index Arithmetic --
⍝----------------------

∇ data← pop11
⍝ DEC PDP11 read from stack
   data← read11 word incr11 Sp
∇

∇ push data
⍝ DEC PDP11 write onto stack
   (word decr11 Sp) write data
∇

⍝------------------------------
⍝-- Integer Domain Signaling --
⍝------------------------------

∇ signal11NZ res
⍝ DEC PDP11 numeric result
   Neg stin 1↑ res
   Zero stin ~∨/res
   Oflo stin 0
∇

∇ signal11NZO res
⍝ DEC PDP11 arithmetic result
   Neg stin 1↑ res
   Zero stin ~∨/res
   Oflo stin xmax∨xmin
∇

⍝----------------------------
⍝-- Floating-point numbers --
⍝----------------------------

∇fl11 size
⍝ DEC PDP11 floating point number
⍝ base
   base←2
⍝ sign encoding
   plus←0
   minus←1
⍝ exponent allocation
   Exp← 1+⍳8
⍝ coefficient allocation
   Coef← 0 0 ,9+⍳size-9
⍝ radix point
   point←0⊥⍴1↓Coef
⍝ extreme exponent
   extexp←radix*0⊥⍴1↓Exp
∇

∇ number← fl11i rep;exponent;coefficient;Exp;Coef
⍝ DEC PDP11 floating-point interpretation
   fl11 ⍴rep
   exponent←biasi rep[Exp]
      →IF exponent≠-extexp
   THEN: ⍝ normalized
      coefficient← signmagni insertbit rep[Coef]
      number← coefficient×base*exponent-point
           →ENDIF
   ELSE: ⍝ zero or undefined
      number←0
      flundef report11fl flstatus[Fiuv]∧1↑rep[Coef]
   ENDIF:
∇

∇ rep← size fl11r number;exponent;coefficient;uflo;Exp;Coef
⍝ DEC PDP11 floating-point representation
   fl11 size
   (-extexp) normalize number
   rep← size⍴0
   IF flstatus[Ft]
   THEN: ⍝ truncate
      rep[Coef]← hidebit (⍴Coef) signmagr truncate coefficient
           →ENDIF:
   ELSE:
      rep[Coef]← hidebit (⍴Coef) signmagr round coefficient
   ENDIF:
   rep[Exp]←(⍴Exp) biasr exponent+xmax
⍝ out of domain
   uflo←(exponent≤-extexp)∧number≠0
   floflo report11fl xmax∧flstatus[Fiv]
   fluflo report11fl uflo∧flstatus[Fiu]
   rep← rep∧~(uflo∧~flstatus[Fiu])
∇


⍝-- floating-point domain signaling --

∇ signal11FNZ r1
⍝ DEC PDP11 float numeric result
   flstatus[Neg]←r1[1↑Coef]
   flstatus[Zero]← ~∨/r1
   flstatus[Oflo]←0
   flstatus[Carry]←0
∇

∇ signal11FNZO res
⍝ DEC PDP11 float arithmetic result
   flstatus[Neg]←res<0
   flstatus[Zero]← res=0
   flstatus[Oflo]←xmax
   flstatus[Carry]←0
∇

⍝------------------------------------
⍝-- Data Manipulation Instructions --
⍝------------------------------------
 
∇MOV ;od
⍝ DEC PDP 11 Move
od ← read11 size11 adr11 Source
(size11 adr11 Dest) write11 od
signal11NZ od
∇
 
⍝-------------------------------
⍝-- Arithmetical Instructions --
⍝-------------------------------
 
∇ADD;dest;ad;addend;augend;sum;rl;cy
⍝ ADD de PDP11 para NO PF
	ad←read11 word adr11 Source
	⍝ Se ejecuta adr11(word,Source)
	⍝ Se lee un word de Source
	⍝ Se ejecuta read con (word,Space,Value)
	⍝ Finalmente, ad contiene word bits de "Space[Value]"
	addend←radixcompi ad
	⍝ Se interpretan los word bits como complemento a la raiz

	dest←word adr11 Dest
	⍝ analogo a ad
	augend←radixcompi read11 dest

	sum←augend+addend
	⍝ Suma a alto nivel, en APL

	rl←word radixcompr sum
	⍝ rl tendra una representacion de word de la suma sum
	dest write11 rl
	⍝ Se escribe en dest la representacion de la suma, es decir, rl
	
	signal11NZO rl
	cy←word carryfrom augend,addend
	Carry stin cy
	⍝ Se marcan los flags de NO ZERO y CARRY
∇

⍝----------------------------
⍝-- Instruction Sequencing --
⍝----------------------------

∇ cycle11
⍝ basic cycle of DEC PDP11
  REPEAT:
     interrupt11
     execute ifetch11
  →UNTIL stop
∇

∇ inst←ifetch11
⍝ DEC PDP11 instruction fetch
   inst←read11 word incr11 Pc
∇

⍝-----------------
⍝-- Supervision --
⍝-----------------

⍝-- Integrity --

∇ adrcheck11 location
⍝ DEC PDP11 address check
⍝ memory capacity
  Spec report location≥memcap
⍝ word allignment
  Spec report 0≠(2⌊⍴,location)|⌊/location
∇

∇  yes←suppress11
⍝ DEC PDP11 operation suppression
  yes←∨/ind[Spec,Invop]
∇

⍝-- Floating-point reports --

∇ code report11fl condition
⍝ floating-point error report
  →If condition
  THEN: ⍝ set indicator and code
     fle←(⍴fle) magnr code
     Fle report 1
  ENDIF:
∇

⍝-- Interruption --

∇ interrup11 ;who;old;new
⍝ DEC PDP11 interrupt action

   progint11
   REPEAT: ⍝ search indicators
      who←ind ⍳ 1
      If who≠⍴ind
      THEN: ⍝ process indicator
         ind[who]←0
         old←stout ⍳word
         push11 old
         push11 reg[Pc;]
         reg[Pc;]← read11 word,memadr,Intvec[who]
         Spec report 1=2|magni reg[Pc;]
         new←read11 word,memadr,2+Intvec[who]
         new[Previousmode]←old[Currentmode]
         (iword) stin new
         wait←0
      ENDIF:
     →UNTIL ~wait
   Bpt report stout Trace
∇

∇ progint11 ;who;nr
⍝ DEC PDP11 programmed interrup
   who←7-(7↑read11 byte,memadr,Piw) ⍳ 1
   →If who>magni stout Priority
   THEN: ⍝ record request number twice
      nr←byte magnr who×34
      (byte,memadr,Piw+1) write11 nr
      Pir report 1
   ENDIF:
∇

⍝--------------------
⍝-- Input / Output --
⍝--------------------

∇name11io
⍝ DEC PDP-11 device addresses
Ttyinw←memcap-142
Ttyoutw←memcap-138
Ptpinw←memcap-150
Ptpoutw←memcap-146
Clockw←memcap-154
Realtimew←memcap-160
Printerw←memcap-178
Disk256w←memcap-210
Disk64w←memcap-242
Dectapew←memcap-288
Diskcrdw←memcap-256
Tapew←memcap-176
∇

∇indicator11io
⍝ DEC PDP input/output indicators
Ttyin←12
Ttyout←13
Ptpin←14
Ptpout←15
Clock←16
Realtime←17
Printer←32
Disk256←33
Disk64←34
Dectape←35
Diskcrd←36
Tape←37
∇

