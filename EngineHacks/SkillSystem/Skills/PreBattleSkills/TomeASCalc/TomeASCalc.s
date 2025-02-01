.thumb
.equ ItemTable, SkillTester+4
.equ TomeASCalcID, ItemTable+4

.macro blh to, reg
    ldr \reg, =\to
    mov lr, \reg
    .short 0xF800
.endm

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

SkillCheck:
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, TomeASCalcID
.short 0xf800
cmp r0, #0
beq End

mov r0, #0x50
ldrb r0, [r4, r0]
cmp		r0, #5			@Check if anima
beq		IsTome
cmp		r0, #6			@Check if light
beq		IsTome
cmp		r0, #7			@Check if dark
beq		IsTome
b		End


@Check inventory
mov	r1, #0x1E @Slot 1

CheckIfTome:
ldrb	r0, [r4, r1]	@Slot weapon type
mov		r5, #0x36
mul		r5, r0
ldr		r6, ItemTable
add		r6, r5
ldrb 	r0, [r6, #0x07]
cmp		r0, #5			@Check if anima
beq		IsTome
cmp		r0, #6			@Check if light
beq		IsTome
cmp		r0, #7			@Check if dark
beq		IsTome
b		End

IsTome:
@First subtract weapon's weight from unit's AS
@Get unit's equipped weapon weight
mov r1,#0x4a
ldrb r0,[r4,r1]
mov r1,#36
mul r0,r1
ldr r1,ItemTable
add r0,r1
mov r1,#23
ldrb r3,[r0,r1]
@and subtract it from unit's AS
mov r1, #0x5E
ldrh r0, [r4, r1] @AS
sub r0, r3
strh r0, [r4,r1]

@Next check if unit is weighed down by equipped weapon
@Get unit's con
ldr r0, [r4, #0x0] 
ldrb r0, [r0, #0x13] @unit Con
ldr r1, [r4, #0x04]
ldrb r1, [r1, #0x11] @class Con
add r0, r1
ldrb r1, [r4, #0x1A] @Con bonus
add r0, r1

@Subtract unit's con from weapon weight - if unit is weighed down, add to unit's as to negate the penalty
sub r3, r0
cmp r3, #0
ble End
mov r1, #0x5E
ldrh r0, [r4, r1] @AS
add r0, r3
strh r0, [r4,r1]

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@POIN SkillTester
@POIN ItemTable
@WORD TomeASCalcID