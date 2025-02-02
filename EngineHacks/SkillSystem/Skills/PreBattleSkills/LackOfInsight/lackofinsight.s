.thumb

.equ LackOfInsightID,SkillTester+4

push {r4-r7,lr}
@goes in the battle loop.
@r0 is the attacker
@r1 is the defender
mov r4, r0
mov r5, r1

ldr r0, SkillTester
mov lr, r0
mov r0, r4
ldr r1, LackOfInsightID
.short 0xf800
cmp r0, #0
beq GoBack

mov r1, #0x62 @Avoid
ldrh r0, [r4, r1]
sub r0, #10
strh r0, [r4,r1]

GoBack:
pop {r4-r7}
pop {r0}
bx r0

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD LackOfInsightID
