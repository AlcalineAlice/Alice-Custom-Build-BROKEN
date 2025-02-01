.thumb
.equ ClassTable, SkillTester+4
.equ ItemTable, ClassTable+4
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
ldr r0, [r5, #0x4]  @Load class ptr from unit struct
mov r1, #0x50       @Offset of Class Type in class struct
ldrb r0, [r0,r1]    @Load class type into r0
cmp r0, #0
beq End             @If the class type is 0, end


@Check if attacker's weapon is effective against that something other than that type
mov r1,#0x4A        @get the weapon ID and uses before battle byte
ldrb r2,[r4,r1]     @load the weapon ID for the attacker
mov r1,#0x24        @move the value that represents the length of the item struct into a register
mul r2,r1           @multiply both together to get the item's position in the item table
ldr r1,ItemTable    @load the item table
add r2,r1           @add both values together to obtain the exact location for the item in the table
mov r1,#0x10        @get the weapon effectiveness byte for defender
ldr r2,[r2,r1]      @load its value
cmp r2, #0          @check if it points to anything
beq End             @if it doesn't, it's not effective against anything - move to end

mov r1,r2
bl IsClassTypeInEffectivenessList
cmp r0,#0
bne End
b   DamageBonus

IsClassTypeInEffectivenessList:
mov r2, #0
IsClassTypeInEffectivenessList.Loop:
ldr r3, [r1, r2]
cmp r3, #0
beq IsClassTypeInEffectivenessList.RetFalse
add r2, r2, #2
ldrh r3, [r1, r2]
and r3, r0
cmp r3, #0
bne IsClassTypeInEffectivenessList.RetTrue
add r2, r2, #2
b IsClassTypeInEffectivenessList.Loop
IsClassTypeInEffectivenessList.RetTrue:
mov r0, #1
b IsClassTypeInEffectivenessList.End
IsClassTypeInEffectivenessList.RetFalse:
mov r0, #0
IsClassTypeInEffectivenessList.End:
bx r14


DamageBonus:
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

/*
IsClassTypeInEffectivenessList:
mov r2, #0
IsClassTypeInEffectivenessList.Loop:
ldr r3, [r1, r2]
cmp r3, #0
beq IsClassTypeInEffectivenessList.RetFalse
add r2, r2, #2
ldrh r3, [r1, r2]
cmp r3, r0
beq IsClassTypeInEffectivenessList.RetTrue
add r2, r2, #2
b IsClassTypeInEffectivenessList.Loop
IsClassTypeInEffectivenessList.RetTrue:
mov r0, #1
b IsClassTypeInEffectivenessList.End
IsClassTypeInEffectivenessList.RetFalse:
mov r0, #0
IsClassTypeInEffectivenessList.End:
bx r14


ldr		r3,=#0x80176D0		@get effectiveness pointer
mov		r2,r3
.short	0xF800
cmp		r2,#0
beq End             @If the weapon effectiveness type is 0 (no effectiveness), end
and     r0,r2       @Check if weapon is effective against defender
cmp     r0,#0       
bne End             @If effective against defender, end. Else apply damage bonus.

mov r1,#0x4A        @get the weapon ID and uses before battle byte
ldrb r2,[r4,r1]     @load the weapon ID for the attacker
mov r1,#0x24        @move the value that represents the length of the item struct into a register
mul r2,r1           @multiply both together to get the item's position in the item table
ldr r1,ItemTable    @load the item table
add r2,r1           @add both values together to obtain the exact location for the item in the table
mov r1,#0x10        @get the weapon effectiveness byte for defender
ldr r2,[r2,r1]      @load its value
cmp r2, #0          @check if it points to anything
beq End             @if it doesn't, it's not effective against anything - move to end
cmp r0, r2          @check if the weapon is effective against the defender
bne End             @if it is, move to end, else apply the damage bonus
*/