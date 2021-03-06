<div id="actionbar">
    <?php if ($task_details['is_closed']): //if task is closed ?>

    <?php if ($user->can_close_task($task_details)): ?>
    <a class="button"
       href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;action=reopen&amp;task_id={$task_details['task_id']}">{L('reopenthistask')}</a>
    <?php elseif (!$user->isAnon() && !Flyspray::adminRequestCheck(2, $task_details['task_id'])): ?>
    <a href="#close" id="reqclose" class="button" onclick="showhidestuff('closeform');">{L('reopenrequest')}</a>

    <div id="closeform" class="popup hide">
        <form name="form3" action="{CreateUrl('details', $task_details['task_id'])}" method="post" id="formclosetask">
            <div>
                <input type="hidden" name="action" value="requestreopen"/>
                <input type="hidden" name="task_id" value="{$task_details['task_id']}"/>
                <label for="reason">{L('reasonforreq')}</label>
                <textarea id="reason" name="reason_given"></textarea><br/>
                <button type="submit">{L('submitreq')}</button>
            </div>
        </form>
    </div>
    <?php endif; ?>

    <?php else:  //if task is open  ?>

    <?php if ($user->can_close_task($task_details) && !$d_open): ?>
    <a href="{CreateUrl('details', $task_details['task_id'], null, array('showclose' => !Req::val('showclose')))}"
       id="closetask" class="button main" accesskey="y"
       onclick="showhidestuff('closeform');return false;"> {L('closetask')}</a>

    <div id="closeform"
         class="<?php if (Req::val('action') != 'details.close' && !Req::val('showclose')): ?>hide <?php endif; ?>popup">
        <form action="{CreateUrl('details', $task_details['task_id'])}" method="post" id="formclosetask">
            <div>
                <input type="hidden" name="action" value="details.close"/>
                <input type="hidden" name="task_id" value="{$task_details['task_id']}"/>
                <select class="adminlist" name="resolution_reason" onmouseup="Event.stop(event);">
                    <option value="0">{L('selectareason')}</option>
                    {!tpl_options($proj->listResolutions(), Req::val('resolution_reason'))}
                </select>
                <button type="submit">{L('closetask')}</button>
                <br/>
                <label class="default text" for="closure_comment">{L('closurecomment')}</label>
                <textarea class="text" id="closure_comment" name="closure_comment" rows="3"
                          cols="25">{Req::val('closure_comment')}</textarea>
                <?php if($task_details['percent_complete'] != '100'): ?>
                <label>{!tpl_checkbox('mark100', Req::val('mark100', !(Req::val('action') == 'details.close')))}&nbsp;&nbsp;{L('mark100')}</label>
                <?php endif; ?>
            </div>
        </form>
    </div>

    <?php elseif (!$d_open && !$user->isAnon() && !Flyspray::AdminRequestCheck(1, $task_details['task_id'])): ?>
    <a href="#close" id="reqclose" class="button main" onclick="showhidestuff('closeform');">{L('requestclose')}</a>

    <div id="closeform" class="popup hide">
        <form name="form3" action="{CreateUrl('details', $task_details['task_id'])}" method="post" id="formclosetask">
            <div>
                <input type="hidden" name="action" value="requestclose"/>
                <input type="hidden" name="task_id" value="{$task_details['task_id']}"/>
                <label for="reason">{L('reasonforreq')}</label>
                <textarea id="reason" name="reason_given"></textarea><br/>
                <button type="submit">{L('submitreq')}</button>
            </div>
        </form>
    </div>
    <?php elseif(!$user->isAnon()): ?>
    <a href="#closedisabled" id="reqclose" class="tooltip button disabled main" ">{L('closetask')}
    <span class="custom info">
                    <em>{L('information')}</em>
                    <br>
        {L('taskclosedisabled')}
        <br>
        <?php foreach ($deps as $dependency)
                    {
                        echo "FS#".$dependency['task_id']." : ".$dependency['item_summary']."</br>";
                    }
                    ?>
                </span>
    </a>
    <?php endif; ?>

    <?php if ($user->can_edit_task($task_details)): ?>
    <a id="edittask" class="button" accesskey="e"
       href="{CreateURL('edittask', $task_details['task_id'])}"> {L('edittask')}</a>
    <?php endif; ?>

    <?php if ($user->can_take_ownership($task_details)): ?>
    <a id="own" class="button"
       href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;task_id={$task_details['task_id']}&amp;action=takeownership&amp;ids={$task_details['task_id']}"> {L('assigntome')}</a>
    <?php endif; ?>

    <?php if ($user->can_add_to_assignees($task_details) && !empty($task_details['assigned_to'])): ?>
    <a id="own_add" class="button"
       href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;task_id={$task_details['task_id']}&amp;action=addtoassignees&amp;ids={$task_details['task_id']}"> {L('addmetoassignees')}</a>
    <?php endif; ?>

    <a href="#" id="actions" class="button main" onclick="showhidestuff('actionsform');">{L('quickaction')}</a>

    <div id="actionsform" class="popup hide">
        <ul>

            <?php if ($user->can_edit_task($task_details)): ?>
            <li>
                <a accesskey="e" href="{CreateURL('edittask', $task_details['task_id'])}"> {L('edittask')}</a>
            </li>
            <?php endif; ?>

            <?php if ($user->can_edit_task($task_details)): ?>
            <li>
                <a href="#" onclick="showhidestuff('setparentform');">{L('setparent')}</a>

                <div id="setparentform" class="hide">
                    </br>
                    <form action="{CreateUrl('details', $task_details['task_id'])}" method="post">
                        {L('parenttaskid')}
                        <input type="hidden" name="action" value="details.setparent"/>
                        <input type="hidden" name="task_id" value="{$task_details['task_id']}"/>
                        <input class="text" type="text" value="" id="supertask_id" name="supertask_id" size="5"
                               maxlength="10"/>
                        <button type="submit" name="submit">{L('set')}</button>
                    </form>
                    </br>
                </div>
            </li>
            <?php endif; ?>
            <?php if ($user->can_edit_task($task_details)): ?>
            <li>
                <a href="#" onclick="showhidestuff('associateform');">{L('associatesubtask')}</a>

                <div id="associateform" class="hide">
                    <br>
                    <form action="{CreateUrl('details', $task_details['task_id'])}" method="post">
                        {L('associatetaskid')}
                        <input type="hidden" name="action" value="details.associatesubtask"/>
                        <input type="hidden" name="task_id" value="{$task_details['task_id']}"/>
                        <input class="text" type="text" value="" id="associate_subtask_id" name="associate_subtask_id"
                               size="5" maxlength="10"/>
                        <button type="submit" name="submit">{L('set')}</button>
                    </form>
                    </br>
                </div>
            </li>
            <?php endif; ?>
            <li>
                <a href="{CreateURL('depends', $task_details['task_id'])}">{L('depgraph')}</a>
            </li>
            <?php if ($user->can_edit_task($task_details)): ?>
            <li>
                <a href="#" onclick="showhidestuff('adddepform');">{L('adddependenttask')}</a>
                <div id="adddepform" class="hide">
                    <br>
                    <form action="{CreateUrl('details', $task_details['task_id'])}" method="post">
                        <label for="dep_task_id">{L('newdependency')}</label>
                        <input type="hidden" name="action" value="details.newdep" />
                        <input type="hidden" name="task_id" value="{$task_details['task_id']}" />
                        <input class="text" type="text" value="{Req::val('dep_task_id')}" id="dep_task_id" name="dep_task_id" size="5" maxlength="10" />
                        <button type="submit" name="submit">{L('add')}</button>
                    </form>
                    </br>
                </div>
            </li>
            <?php endif; ?>

            <?php if ($proj->id && $user->perms('open_new_tasks')): ?>
            <li>
                <a href="{CreateURL('newtask', $proj->id, $task_details['task_id'])}">{L('addnewsubtask')}</a>
            </li>
            <?php endif; ?>

            <?php if ($user->can_take_ownership($task_details)): ?>
            <li>
                <a href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;task_id={$task_details['task_id']}&amp;action=takeownership&amp;ids={$task_details['task_id']}"> {L('assigntome')}</a>
            </li>
            <?php endif; ?>


            <?php if ($user->can_add_to_assignees($task_details) && !empty($task_details['assigned_to'])): ?>
            <li>
                <a href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;task_id={$task_details['task_id']}&amp;action=addtoassignees&amp;ids={$task_details['task_id']}"> {L('addmetoassignees')}</a>
            </li>
            <?php endif; ?>


            <?php if ($user->can_vote($task_details) > 0): ?>
            <li>
                <a href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;action=details.addvote&amp;task_id={$task_details['task_id']}">{L('voteforthistask')}</a>
            </li>
            <?php endif; ?>


            <?php if (!$user->isAnon()): ?>
            <?php if (!$watched): ?>
            <li>
                <a href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;task_id={$task_details['task_id']}&amp;action=details.add_notification&amp;ids={$task_details['task_id']}&amp;user_id={$user->id}">{L('watchthistask')}</a>
            </li>
            <?php endif; ?>
            <?php endif; ?>


            <?php if ($user->can_change_private($task_details) && !$task_details['mark_private']): ?>
            <li>
                <a href="#">{L('privatethistask')}</a>
            </li>
            <?php endif; ?>

        </ul>
    </div>

    <?php endif; ?>
</div>


<!-- Grab fields wanted for this project so we can only show those we want -->
<?php $fields = explode( ' ', $proj->prefs['visible_fields'] ); ?>

<div id="taskdetails">
	<span id="navigation"> <?php if ($prev_id): ?>
        {!tpl_tasklink($prev_id, L('previoustask'), false, array('id'=>'prev', 'accesskey' => 'p'))}
        <?php endif; ?>
        <?php if ($prev_id): ?> | <?php endif; ?>
        <?php
		if($_COOKIE['tasklist_type'] == 'project'):
			$params = $_GET; unset($params['do'], $params['action'], $params['task_id'], $params['switch'], $params['project']); 
			?>
        <a href="{CreateUrl('project', $proj->id, null, array('do' => 'index') + $params)}">{L('tasklist')}</a>
        <?php endif; ?>
        <?php if ($_COOKIE['tasklist_type'] == 'assignedtome'): ?>
        <a href="{CreateURL('project', $proj->id, null, array('do' => 'index', 'dev' => $user->id))}">My Assigned
            Tasks</a>
        <?php endif; ?>

        <?php if ($next_id): ?> | <?php endif; ?>
        <?php if ($next_id): ?>
        {!tpl_tasklink($next_id, L('nexttask'), false, array('id'=>'next', 'accesskey' => 'n'))}
        <?php endif; ?>
	</span>

    <div id="taskfields">
    <ul class="fieldslist">
        <!-- Status -->
        <?php if (in_array('status', $fields)): ?>
        <li>
            <span class="label">{L('status')}</span>
				<span class="value">
					<?php if ($task_details['is_closed']): ?>
                    {L('closed')}
                    <?php else: ?>
                    {$task_details['status_name']}
                    <?php if ($reopened): ?>
                    &nbsp; <strong class="reopened">{L('reopened')}</strong>
                    <?php endif; ?>
                    <?php endif; ?>
				</span>
        </li>
        <?php endif; ?>

        <!-- Progress -->
        <?php if (in_array('progress', $fields)): ?>
        <li>
            <span class="label">{L('percentcomplete')}</span>
				<span class="value">
					<div class="progress_bar_container" style="width: 90px">
                        <span>{$task_details['percent_complete']}%</span>

                        <div class="progress_bar" style="width:{$task_details['percent_complete']}%"></div>
                    </div>
				</span>
        </li>
        <?php endif; ?>
    </ul>
    <ul class="fieldslist">
        <!-- Task Type-->
        <?php if (in_array('tasktype', $fields)): ?>
        <li>
            <span class="label">{L('tasktype')}</span>
            <span class="value">{$task_details['tasktype_name']}</span>
        </li>
        <?php endif; ?>

        <!-- Category -->
        <?php if (in_array('category', $fields)): ?>
        <li>
            <span class="label">{L('category')}</span>
				<span class="value">
					<?php foreach ($parent as $cat): ?>
                    {$cat['category_name']} &#8594;
                    <?php endforeach; ?>
                    {$task_details['category_name']}
				</span>
        </li>
        <?php endif; ?>

        <!-- Assigned To-->
        <?php if (in_array('assignedto', $fields)): ?>
        <li>
            <span class="label">{L('assignedto')}</span>
				<span class="value assignedto">
					<?php if (empty($assigned_users)): ?>
                    {L('noone')}
                    <?php else: ?>
                    <table class="assignedto">
                        <?php
					foreach ($assigned_users as $userid):
					?>
                        <?php if($fs->prefs['gravatars'] == 1) {?>
                        <tr><td>{!tpl_userlinkgravatar($userid, 26)}</td><td>{!tpl_userlink($userid)}</td></tr>
                        <?php } else { ?>
                        <tr>
                            <td class="assignedto_name">{!tpl_userlink($userid)}</td>
                        </tr>
                        <?php } ?>
                        <?php endforeach;
					?>
                    </table>
                    <?php
					endif; ?>
				</span>
        </li>
        <?php endif; ?>

        <!-- OS -->
        <?php if (in_array('os', $fields)): ?>
        <li>
            <span class="label">{L('operatingsystem')}</span>
            <span class="value">{$task_details['os_name']}</span>
        </li>
        <?php endif; ?>

        <!-- Severity -->
        <?php if (in_array('severity', $fields)): ?>
        <li>
            <span class="label">{L('severity')}</span>
            <span class="value">{$task_details['severity_name']}</span>
        </li>
        <?php endif; ?>

        <!-- Priority -->
        <?php if (in_array('priority', $fields)): ?>
        <li>
            <span class="label">{L('priority')}</span>
            <span class="value">{$task_details['priority_name']}</span>
        </li>
        <?php endif; ?>

        <!-- Reported In -->
        <?php if (in_array('reportedin', $fields)): ?>
        <li>
            <span class="label">{L('reportedversion')}</span>
            <span class="value">{$task_details['reported_version_name']}</span>
        </li>
        <?php endif; ?>

        <!-- Due -->
        <?php if (in_array('dueversion', $fields)): ?>
        <li>
            <span class="label">{L('dueinversion')}</span>
				<span class="value"><?php if ($task_details['due_in_version_name']): ?>
                    {$task_details['due_in_version_name']}
                    <?php else: ?>
                    {L('undecided')}
                    <?php endif; ?>
				</span>
        </li>
        <?php endif; ?>

        <!-- Due Date -->
        <?php if (in_array('duedate', $fields)): ?>
        <li>
            <span class="label">{L('duedate')}</span>
				<span class="value">{formatDate($task_details['due_date'], false, L('undecided'))}<br><?php
				$days = (strtotime(date('c', $task_details['due_date'])) - strtotime(date("Y-m-d"))) / (60 * 60 * 24);
				if($task_details['due_date'] > 0)
				{
					if($days <$fs->prefs['days_before_alert'] && $days > 0)
					{
						echo "<font style='color: red; font-weight: bold'>".$days." ".L('daysleft')."</font>";
					}
					elseif($days < 0)
					{
						echo "<font style='color: red; font-weight: bold'>".str_replace('-', '', $days)."
                        ".L('daysoverdue')."</font>";
					}
					elseif($days == 0)
					{
						echo "<font style='color: red; font-weight: bold'>".L('duetoday')."</font>";
					}
					else
					{
						echo $days." ".L('daysleft');
					}
				}
				?>
				</span>
        </li>
        <?php endif; ?>
        <?php if($proj->prefs['use_effort_tracking']) {
        ?>
        <li style="...">
            <span class="label">{L('estimatedeffort')}</span>
            <span class="value"><?php echo ConvertSeconds($task_details['estimated_effort']*60*60); ?></span>
        </li>
        <li style="...">
            <span class="label">{L('actualeffort')}</span>
            <?php
            $total_effort = 0;
            foreach($effort->details as $details){
            $total_effort += $details['effort'];
            }
            ?>
            <span class="value"><?php echo ConvertSeconds($total_effort); ?> </span>
        </li>
        <?php } ?>
    </ul>
    <ul class="fieldslist">
        <!-- Votes-->
        <?php if (in_array('votes', $fields)): ?>
        <li class="votes">
            <span class="label">{L('votes')}</span>
				<span class="value">
					<?php if (count($votes)): ?>
                    <a href="javascript:showhidestuff('showvotes')">{count($votes)} </a>
					<div id="showvotes" class="hide">
                        <ul class="reports">
                            <?php foreach ($votes as $vote): ?>
                            <li>{!tpl_userlink($vote)} ({formatDate($vote['date_time'])})</li>
                            <?php endforeach; ?>
                        </ul>
                    </div>
                    <?php else: ?>
                    0
                    <?php endif; ?>
                    <?php if ($user->can_vote($task_details) > 0): ?>
					<a href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;action=details.addvote&amp;task_id={$task_details['task_id']}">
                        ({L('addvote')})</a>
                    <?php elseif ($user->can_vote($task_details) == -2): ?>
					({L('alreadyvotedthistask')})
                    <?php elseif ($user->can_vote($task_details) == -3): ?>
					({L('alreadyvotedthisday')})
                    <?php endif; ?>
				</span>
        </li>
        <?php endif; ?>

        <!-- Private -->
        <?php if (in_array('private', $fields)): ?>
        <li>
            <span class="label">{L('private')}</span>
				<span class="value">
						<?php if ($task_details['mark_private']): ?>
                    {L('yes')}
                    <?php else: ?>
                    {L('no')}
                    <?php endif; ?>

                    <?php if ($user->can_change_private($task_details) && $task_details['mark_private']): ?>
						<a href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;action=makepublic&amp;task_id={$task_details['task_id']}">
                            ({L('makepublic')})</a>
                    <?php elseif ($user->can_change_private($task_details) && !$task_details['mark_private']): ?>
						<a href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;action=makeprivate&amp;task_id={$task_details['task_id']}">
                            ({L('makeprivate')})</a>
                    <?php endif; ?>
				</span>
        </li>
        <?php endif; ?>


        <!-- Watching -->
        <?php if (!$user->isAnon()): ?>
        <li>
            <span class="label">{L('watching')}</span>
				<span class="value">
							<?php if ($watched): ?>
                    {L('yes')}
                    <?php else: ?>
                    {L('no')}
                    <?php endif; ?>

                    <?php if (!$watched): ?>
                    <a accesskey="w"
                       href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;task_id={$task_details['task_id']}&amp;action=details.add_notification&amp;ids={$task_details['task_id']}&amp;user_id={$user->id}">
                        ({L('watchtask')})</a>
                    <?php else: ?>
                    <a accesskey="w"
                       href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;task_id={$task_details['task_id']}&amp;action=remove_notification&amp;ids={$task_details['task_id']}&amp;user_id={$user->id}">
                        ({L('stopwatching')})</a>
                    <?php endif; ?>
				</span>
        </li>
        <?php endif; ?>
    </ul>

    <div id="fineprint">
        {L('attachedtoproject')}: <a
                href="{$_SERVER['SCRIPT_NAME']}?project={$task_details['project_id']}">{$task_details['project_title']}</a>
        <br/>
        {L('openedby')} {!tpl_userlink($task_details['opened_by'])}
        <?php if ($task_details['anon_email'] && $user->perms('view_tasks')): ?>
        ({$task_details['anon_email']})
        <?php endif; ?>
        -
        <span title="{formatDate($task_details['date_opened'], true)}">{formatDate($task_details['date_opened'], false)}</span>
        <?php if ($task_details['last_edited_by']): ?>
        <br/>
        {L('editedby')}  {!tpl_userlink($task_details['last_edited_by'])}
        -
        <span title="{formatDate($task_details['last_edited_time'], true)}">{formatDate($task_details['last_edited_time'], false)}</span>
        <?php endif; ?>
    </div>

    </div>


    <div id="taskdetailsfull">
        <h2 class="summary severity{$task_details['task_severity']}">
            FS#{$task_details['task_id']} - {$task_details['item_summary']}
        </h2>
        <h4>
            Tags: {$tag_list}
        </h4>
        <!--<h3 class="taskdesc">{L('details')}</h3>-->

        <div id="taskdetailstext">{!$task_text}</div>

        <?php $attachments = $proj->listTaskAttachments($task_details['task_id']);
        $this->display('common.attachments.tpl', 'attachments', $attachments); ?>
    </div>

    <div id="taskinfo">
        <?php if(!count($deps)==0): ?>
        <?php $projects = $fs->listProjects(); ?>
        <table id="dependency_table" class="table" width="100%">
            <caption>This task depends on the following tasks.</caption>
            <thead>
            <tr>
                <th>{L('id')}</th>
                <th>{L('project')}</th>
                <th>{L('summary')}</th>
                <th>{L('priority')}</th>
                <th>{L('severity')}</th>
                <th>{L('progress')}</th>
                <th>{L('assignedto')}</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <?php foreach ($deps as $dependency): ?>
            <tr>
                <td><?php echo $dependency['task_id'] ?></td>
                <td><?php echo $projects[$dependency['project_id']-1]['project_title'] ?></td>
                <td>{!tpl_tasklink($dependency['task_id'])}</td>
                <td><?php echo $fs->priorities[$dependency['task_priority']] ?></td>
                <td class="severity{$dependency['task_severity']}"><?php echo $fs->
                    severities[$dependency['task_severity']] ?>
                </td>
                <td class="task_progress">
                    <div class="progress_bar_container">
                        <span>{$dependency['percent_complete']}%</span>

                        <div class="progress_bar" style="width:{$dependency['percent_complete']}%"></div>
                    </div>
                </td>
                <td>Assignees TODO</td>
                <td>
                    <a class="removedeplink"
                       href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;action=removedep&amp;depend_id={$dependency['depend_id']}&amp;task_id={$task_details['task_id']}&amp;taskid={$task_details['task_id']}">
                        <img src="{$this->get_image('button_cancel')}" alt="{L('remove')}" title="{L('remove')}"/>
                    </a>
                </td>
            </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
        <?php endif; ?>
        <?php
            if (!$task_details['supertask_id']==0)
            {
                $task_description = "&nbsp;&nbsp;This task is a sub task of ". ': ' . tpl_tasklink($task_details['supertask_id']);
                print $task_description;
            }

        ?>
        <?php if(!count($subtasks)==0): ?>
        <?php $projects = $fs->listProjects(); ?>
        <table id="subtask_table" class="table" width="100%">
            <caption>This task has the following sub-tasks.</caption>
            <thead>
            <tr>
                <th>{L('id')}</th>
                <th>{L('project')}</th>
                <th>{L('summary')}</th>
                <th>{L('priority')}</th>
                <th>{L('severity')}</th>
                <th>{L('progress')}</th>
                <th>{L('assignedto')}</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <?php foreach ($subtasks as $subtaskOrgin): ?>
            <?php $subtask = $fs->GetTaskDetails($subtaskOrgin['task_id']); ?>
            <tr id="task{!$subtask['task_id']}" class="severity{$subtask['task_severity']}">
                <td><?php echo $subtask['task_id'] ?></td>
                <td><?php echo $projects[$subtask['project_id']-1]['project_title'] ?></td>
                <td>{!tpl_tasklink($subtask['task_id'])}</td>
                <td><?php echo $fs->priorities[$subtask['task_priority']] ?></td>
                <td class="severity{$subtask['task_severity']}"><?php echo $fs->severities[$subtask['task_severity']]
                    ?>
                </td>
                <td class="task_progress">
                    <div class="progress_bar_container">
                        <span>{$subtask['percent_complete']}%</span>

                        <div class="progress_bar" style="width:{$subtask['percent_complete']}%"></div>
                    </div>
                </td>
                <td>Assignees TODO</td>
                <td>
                    <a class="removedeplink"
                       href="{$_SERVER['SCRIPT_NAME']}?do=details&amp;action=removesubtask&amp;subtaskid={$subtask['task_id']}&amp;taskid={$task_details['task_id']}">
                        <img src="{$this->get_image('button_cancel')}" alt="{L('remove')}" title="{L('remove')}"/>
                    </a>
                </td>
            </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
        <?php endif; ?>
    </div>
</div>

<?php if ($task_details['is_closed']): ?>
<div id="taskclosed">
    {L('closedby')}&nbsp;&nbsp;{!tpl_userlink($task_details['closed_by'])}<br/>
    {formatDate($task_details['date_closed'], true)}<br/>
    <strong>{L('reasonforclosing')}</strong> &nbsp;{$task_details['resolution_name']}<br/>
    <?php if ($task_details['closure_comment']): ?>
    <strong>{L('closurecomment')}</strong>
    &nbsp;{!wordwrap(TextFormatter::render($task_details['closure_comment']), 40, "\n", true)}
    <?php endif; ?>
</div>
<?php endif; ?>

<div id="actionbuttons">

    <?php if (count($penreqs)): ?>
    <div class="pendingreq"><strong>{formatDate($penreqs[0]['time_submitted'])}
            : {L('request'.$penreqs[0]['request_type'])}</strong>
        <?php if ($penreqs[0]['reason_given']): ?>
        {L('reasonforreq')}: {$penreqs[0]['reason_given']}
        <?php endif; ?>
    </div>
    <?php endif; ?>
</div>

<div class="clear"></div>
</div>

