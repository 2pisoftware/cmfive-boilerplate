import { test } from "@playwright/test";
import { TimelogHelper } from "./timelog.helper";
import { TaskHelper } from "./task.helper";
import { GLOBAL_TIMEOUT, CmfiveHelper } from "./cmfive.helper";
import { DateTime } from "luxon";

test.describe.configure({mode: 'parallel'});

test("You can create a Timelog using Timer" , async ({page}) => {
    test.setTimeout(GLOBAL_TIMEOUT);

    await CmfiveHelper.login(page, "admin", "admin");
    
    const taskgroup = CmfiveHelper.randomID("taskgroup_");
    await TaskHelper.createTaskGroup(page, taskgroup, "Software Development", "OWNER", "OWNER", "OWNER");
    await TaskHelper.addMemberToTaskgroup(page, taskgroup, "Admin Admin", "OWNER");
    await TaskHelper.setDefaultAssignee(page, taskgroup, "Admin Admin");

    const task = CmfiveHelper.randomID("task_");
    await TaskHelper.createTask(page, task, taskgroup, "Software Development");
    
    const timelog = CmfiveHelper.randomID("timelog_");
    await TimelogHelper.createTimelogFromTimer(page, timelog, task);
    
    await TimelogHelper.deleteTimelog(page, timelog, task);
    await TaskHelper.deleteTask(page, task);
    await TaskHelper.deleteTaskGroup(page, taskgroup);
});

test("You can create a Timelog using Add Timelog" , async ({page}) => {
    test.setTimeout(GLOBAL_TIMEOUT);

    await CmfiveHelper.login(page, "admin", "admin");
    
    const taskgroup = CmfiveHelper.randomID("taskgroup_");
    await TaskHelper.createTaskGroup(page, taskgroup, "Software Development", "OWNER", "OWNER", "OWNER");
    await TaskHelper.addMemberToTaskgroup(page, taskgroup, "Admin Admin", "OWNER");
    await TaskHelper.setDefaultAssignee(page, taskgroup, "Admin Admin");

    const task = CmfiveHelper.randomID("task_");
    await TaskHelper.createTask(page, task, taskgroup, "Software Development");

    const timelog = CmfiveHelper.randomID("timelog_");
    await TimelogHelper.createTimelog(
        page,
        timelog,
        task,
        DateTime.fromFormat("1/1/2021", "d/M/yyyy"),
        "10:00",
        "11:00",
    );
    
    await TimelogHelper.deleteTimelog(page, timelog, task);
    await TaskHelper.deleteTask(page, task);
    await TaskHelper.deleteTaskGroup(page, taskgroup);
});