/**
 * Created by EvgeniyMalahovskiy on 8/31/2022.
 */

({
    fireGlobal: function (cmp, event, helper) {
        var actionAPI = cmp.find("quickActionAPI");

        var args = { actionName: "Convert_Lead" };
        actionAPI.invokeAction(args);
    }
});