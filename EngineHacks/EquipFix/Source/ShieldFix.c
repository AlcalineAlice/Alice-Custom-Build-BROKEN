#include "gbafe.h"

#define FORCE_DECLARE __attribute__((unused))
#define NOINLINE __attribute__((noinline))
#define STATIC_DEC static FORCE_DECLARE NOINLINE

extern const u8 OffenseEquipmentList[];
extern const u8 StaffEquipmentList[];

STATIC_DEC u8 *GetAttacksMade(struct BattleUnit *bu)
{
	return ((u8 *)bu + 0x7E);
}

STATIC_DEC u8 *GetHitsTaken(struct BattleUnit *bu)
{
	return ((u8 *)bu + 0x7F);
}

STATIC_DEC void AddAttacksMade(struct BattleUnit *bu)
{
	*GetAttacksMade(bu) = *GetAttacksMade(bu) + 1;
}

STATIC_DEC bool IsItemEquipmentExt(int item, const u8 *list)
{
	const u8 *it;
	int iid = ITEM_INDEX(item);

	if (iid == ITEM_NONE)
		return false;

	for (it = list; *it != 0; it++)
		if (*it == iid)
			return true;

	return false;
}

STATIC_DEC bool IsItemOffenseEquipmentOld(int item)
{
	return IsItemEquipmentExt(item, OffenseEquipmentList);
}

STATIC_DEC bool IsItemOffenseEquipmentStaff(int item)
{
	return IsItemEquipmentExt(item, StaffEquipmentList);
}

bool IsItemOffenseEquipmentMokhaRework(int item)
{
	if (GetItemAttributes(item) & IA_STAFF)
		return IsItemOffenseEquipmentStaff(item);
	
	return IsItemOffenseEquipmentOld(item);
}

void ActionStaffMokhaRework(ProcPtr proc)
{
	ActionStaffDoorChestUseItem(proc);
	GetAttacksMade(&gBattleActor);
}
