.thumb
.equ ItemTable, SkillTester+4
.equ UnorthodoxID, ItemTable+4
push	{r4,r5,r14}     @Test for the skill
mov		r4,r0
mov		r5,r1
ldr		r0,[r5,#0x4]
cmp		r0,#0
beq		End
mov		r0,r4
ldr		r1,SkillTester
mov		r14,r1
ldr		r1,UnorthodoxID
.short  0xF800
cmp		r0,#0x0
beq		End

@Check if defender has a class type
ldr		r0,[r5]
ldr		r0,[r0,#0x28]   @Get class data
ldr		r1,[r5,#0x4]
ldr		r1,[r1,#0x28]
orr		r0,r1           @Check if unit has a class type
mov     r1,#0
tst		r0,r1
bne 	End             @If not, go to end

@Check if attacker's weapon is effective against that something other than that type
mov r1,#0x4A        @get the weapon ID and uses before battle byte
ldrb r2,[r4,r1]     @load the weapon ID for the defender seperately by loading it as a byte instead of a short
mov r1,#0x24        @move the value that represents the length of the item struct into a register
mul r2,r1           @multiply both together to get the item's position in the item table
ldr r1,ItemTable    @load the item table
add r2,r1           @add both values together to obtain the exact location for the item in the table
mov r1,#0x10        @get the weapon effectiveness byte for defender
ldr r2,[r2,r1]      @load its value
cmp r2, #0          @check if it points to anything
beq End             @if it doesn't, it's not effective against anything - move to end
and r0, r2          @check if the weapon is effective against the class
cmp r0, #0
bne End             @if it is, move to end, else apply the damage bonus

add		r4,#0x5A
ldrh	r0,[r4]
add		r0,#3
strh	r0,[r4]

End:
pop		{r4-r5}
pop		{r0}
bx		r0

.align
SkillTester:
@POIN SkillTester
@WORD UnorthodoxID