/**
 * Created by EvgeniyMalahovskiy on 7/28/2022.
 */

public without sharing class UserService {
    private static final Map<String,String> REX_COMPANIES_PUBLIC_GROUPS_TO_PROFILE = new Map<String,String>{
        'CapOps Admin' => 'CapOps Group',
        'GetDone' => 'GetDone Group',
        'IDcore' => 'IDCore Group',
        'InsurePro' => 'InsurePro Group',
        'JobCall' => 'JobCall Group',
        'OwnProp' => 'OwnProp Group',
        'PayUp' => 'PayUp Group',
        'PrimePro' => 'PrimePro Group',
        'PropData' => 'PropData Group',
        'ShopSupply' => 'ShopSupply Group',
        'SmartFuse' => 'SmartFuse Group'
    };

    @Future
    public static void addUserToPublicGroup(Set<Id> newUserIds) {
        Map<String, Group> groupMapByName = getGroupsByName();
        if (groupMapByName.isEmpty()) return;

        List<User> usersWithProfileName = getUsersWithProfileName(newUserIds);

        List<GroupMember> groupMembersForInsert = new List<GroupMember>();
        Set<Id> usedIdsForCheck = new Set<Id>();

        for (User user : usersWithProfileName) {
            if (REX_COMPANIES_PUBLIC_GROUPS_TO_PROFILE.containsKey(user.Profile.Name)) {
                usedIdsForCheck.add(user.Id);
                groupMembersForInsert.add(new GroupMember(
                    GroupId = groupMapByName.get(REX_COMPANIES_PUBLIC_GROUPS_TO_PROFILE.get(user.Profile.Name)).Id,
                    UserOrGroupId = user.Id
                ));
            }
        }

        cleanOldGroupMembers(usedIdsForCheck, groupMapByName.values());

        if (!groupMembersForInsert.isEmpty()) {
            insert groupMembersForInsert;
        }
    }

    private static void cleanOldGroupMembers(Set<Id> usedIdsForCheck, List<Group> groupsForCheck) {
        List<GroupMember> groupMembersForDelete = new List<GroupMember>();

        for (Group groupForCheck : groupsForCheck) {
            for (GroupMember groupMember : groupForCheck.GroupMembers) {
                if (usedIdsForCheck.contains(groupMember.UserOrGroupId)) {
                    groupMembersForDelete.add(groupMember);
                }
            }
        }

        if (!groupMembersForDelete.isEmpty()) {
            delete groupMembersForDelete;
        }
    }

    public static Set<Id> getUserIdsWithChangedProfile(List<User> newRecords, Map<Id, User> oldRecords) {
        Set<Id> userIds = new Set<Id>();

        for (User user : newRecords) {
            if (user.ProfileId != oldRecords.get(user.Id).ProfileId && user.IsActive) {
                userIds.add(user.Id);
            }
        }

        return userIds;
    }

    private static Map<String, Group> getGroupsByName() {
        Map<String, Group> groupMapByName = new Map<String, Group>();
        for (Group groupItem : [SELECT Id, Name, (SELECT Id, UserOrGroupId FROM GroupMembers) FROM Group WHERE Name != null]) {
            groupMapByName.put(groupItem.Name, groupItem);
        }
        return groupMapByName;
    }

    private static List<User> getUsersWithProfileName(Set<Id> newUserIds) {
        return [SELECT Id, Profile.Name FROM User WHERE Id IN :newUserIds];
    }
}