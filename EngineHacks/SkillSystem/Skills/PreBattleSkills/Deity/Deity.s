.equ ItemTable, SkillTester+4
.equ DeityID, ItemTable+4
.equ gBattleData, 0x203a4d4
.equ DragonEffectiveness, 0x8B4DF44
.thumb
push {r4-r7,lr}
@goes in the battle loop.
@r0 is the defender
@r1 is the attacker
mov r4, r0
mov r5, r1

@make sure we're in combat (or battle forecast)
ldrb r3, =gBattleData
ldrb r3, [r3]
cmp r3, #4
beq End

ldr r0,=#0x203A56C
cmp r0, r4
bne End @Defender's def isn't calculated yet, so end

@skillcheck for attacker
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, DeityID
.short 0xf800
cmp r0, #0
beq DefenderCheck

@Check if defender has an S rank weapon
mov r1,#0x4A        @get the weapon ID and uses before battle byte
ldrb r0,[r5,r1]     @load the weapon ID for the defender seperately by loading it as a byte instead of a short
mov r1,#0x24        @move the value that represents the length of the item struct into a register
mul r0,r1           @multiply both together to get the item's position in the item table
ldr r1,ItemTable    @load the item table
add r0,r1           @add both values together to obtain the exact location for the item in the table
mov r1,#0x1C        @get the weapon rank byte for defender
ldrb r0,[r0,r1]     @load its value
cmp r0, #251        @check if S rank
bne HalveDefenderDamage     @if not S rank, reduce damage as normal

@Check if defender's weapon is dragon effective
mov r1,#0x4A        @get the weapon ID and uses before battle byte
ldrb r0,[r5,r1]     @load the weapon ID for the defender seperately by loading it as a byte instead of a short
mov r1,#0x24        @move the value that represents the length of the item struct into a register
mul r0,r1           @multiply both together to get the item's position in the item table
ldr r1,ItemTable    @load the item table
add r0,r1           @add both values together to obtain the exact location for the item in the table
mov r1,#0x10        @get the weapon effectiveness byte for defender
ldr r0,[r0,r1]     @load its value
ldr r2,=DragonEffectiveness     @load the dragon effectiveness pointer
cmp r0, r2          @check if it points to DragonEffectiveness
beq DefenderCheck   @if it is, don't reduce damage

HalveDefenderDamage:
mov r1, r4
add r1, #0x5C  		@defender def
ldrh r2,[r1]		@load it to register

mov r0, r5
add r0,#0x5A		@attacker atk
ldrh r3,[r0]		@load it to register
cmp r2,r3
bge DefenderCheck 	@no damage -> Go to attacker check

sub r3,r2 		    @subtract def from attack
lsr r3,#0x1			@divide by two
strh r3,[r0]		@store
mov r0,#0x0
strh r0, [r1]		@make defenders def 0


@skillcheck for defender
DefenderCheck:
ldr r0, SkillTester
mov lr, r0
mov r0, r5 @attacker data
ldr r1, DeityID
.short 0xf800
cmp r0, #0
beq End

@Check if attacker has an S rank weapon
mov r1,#0x4A        @get the weapon ID and uses before battle byte
ldrb r0,[r4,r1]     @load the weapon ID for the defender seperately by loading it as a byte instead of a short
mov r1,#0x24        @move the value that represents the length of the item struct into a register
mul r0,r1           @multiply both together to get the item's position in the item table
ldr r1,ItemTable    @load the item table
add r0,r1           @add both values together to obtain the exact location for the item in the table
mov r1,#0x1C        @get the weapon rank byte for defender
ldrb r0,[r0,r1]     @load its value
cmp r0, #251        @check if S rank
bne HalveAttackerDamage     @if not S rank, reduce damage as normal

@Check if attacker's weapon is dragon effective
mov r1,#0x4A        @get the weapon ID and uses before battle byte
ldrb r0,[r4,r1]     @load the weapon ID for the defender seperately by loading it as a byte instead of a short
mov r1,#0x24        @move the value that represents the length of the item struct into a register
mul r0,r1           @multiply both together to get the item's position in the item table
ldr r1,ItemTable    @load the item table
add r0,r1           @add both values together to obtain the exact location for the item in the table
mov r1,#0x10        @get the weapon effectiveness byte for defender
ldr r0,[r0,r1]      @load its value
ldr r2,=DragonEffectiveness     @load the dragon effectiveness pointer
cmp r0, r2          @check if it points to DragonEffectiveness
beq End             @if it is, don't reduce damage


HalveAttackerDamage:
mov r1, r5
add r1, #0x5C  		@attacker def
ldrh r2,[r1]		@load it to register

mov r0, r4
add r0,#0x5A		@defender atk
ldrh r3,[r0]		@load it to register
cmp r2,r3
bge End				@no damage -> End

sub r3,r2 		    @subtract def from attack
lsr r3,#0x1			@divide by two
strh r3,[r0]		@store
mov r0,#0x0
strh r0, [r1]		@make attackers def 0

End:
pop {r4-r7}
pop {r0}
bx r0

.ltorg
.align

SkillTester:
@POIN SkillTester
@WORD DeityID

@0x8B4DF44 - DragonEffectiveness sym file pointer
@0x88ADF13 - DragonEffectiveness pointer in FEBuilder. Are these seperate?