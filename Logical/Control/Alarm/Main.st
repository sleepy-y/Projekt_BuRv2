
PROGRAM _INIT
	(* Insert code here *)
	MpAlarmXCore_0.MpLink :=  ADR(gAlarmXCore);
	MpAlarmXCore_0.Enable := TRUE;
	MpAlarmXHistory_0.MpLink :=  ADR(gAlarmXHistory);
	MpAlarmXHistory_0.Enable := TRUE;
	MpAlarmXCore_0();
	MpAlarmXHistory_0();
	mpAlarmXlist.MpLink :=ADR(gAlarmXCore);
	mpAlarmXlist.Enable := TRUE;
	mpAlarmXlist.UIConnect := ADR(mpAlarmXlistConnect);
	mpAlarmXlist.UISetup := MpAlarmXlistSetup;
	//initialization
	Temp1Alarm;
	Temp2Alarm;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	MpAlarmXCore_0();
	MpAlarmXHistory_0();
	mpAlarmXlist();
	IF MpAlarmXCheckReaction(gAlarmXCore,'StatusIdle') THEN
		Automatic_work := FALSE;
		Manual_work := FALSE;
		TuneEnable := FALSE;
		gStart := FALSE;
		gSTOP := FALSE;
		gError := FALSE;
		STATUS := STATE_IDLE;
	END_IF;
		
	Alarms.Pending := MpAlarmXCore_0.PendingAlarms;
	Alarms.Active :=  MpAlarmXCore_0.ActiveAlarms;
	Alarms.ActiveAlarms := '';
	FOR i:=0 TO 49 BY 1 DO
		IF NOT (mpAlarmXlistConnect.AlarmList.Code[i]=0) THEN
			stringBuffer := UDINT_TO_STRING(mpAlarmXlistConnect.AlarmList.Code[i]);
			brsstrcat(ADR(Alarms.ActiveAlarms),ADR(stringBuffer));
			
			stringBuffer := ';';
			brsstrcat(ADR(Alarms.ActiveAlarms),ADR(stringBuffer));
			
			stringBuffer := WSTRING_TO_STRING(mpAlarmXlistConnect.AlarmList.Message[i]);
			brsstrcat(ADR(Alarms.ActiveAlarms),ADR(stringBuffer));
			
			stringBuffer := ';';
			brsstrcat(ADR(Alarms.ActiveAlarms),ADR(stringBuffer));
			
			stringBuffer := (mpAlarmXlistConnect.AlarmList.Timestamp[i]);
			brsstrcat(ADR(Alarms.ActiveAlarms),ADR(stringBuffer));
			
			stringBuffer := ';';
			brsstrcat(ADR(Alarms.ActiveAlarms),ADR(stringBuffer));
			
			stringBuffer := BOOL_TO_STRING(mpAlarmXlistConnect.AlarmList.StateAcknowledged[i]);
			brsstrcat(ADR(Alarms.ActiveAlarms),ADR(stringBuffer));
			
			stringBuffer := ';';
			brsstrcat(ADR(Alarms.ActiveAlarms),ADR(stringBuffer));
			
			stringBuffer := BOOL_TO_STRING(mpAlarmXlistConnect.AlarmList.StateActive[i]);
			brsstrcat(ADR(Alarms.ActiveAlarms),ADR(stringBuffer));
			
			IF NOT (i=49 OR mpAlarmXlistConnect.AlarmList.Code[i+1]=0) THEN
				stringBuffer :=',';
				brsstrcat(ADR(Alarms.ActiveAlarms),ADR(stringBuffer));
			END_IF
		END_IF
	END_FOR
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	MpAlarmXCore_0.Enable := FALSE;
	MpAlarmXHistory_0.Enable := FALSE;
	mpAlarmXlist.Enable := FALSE;
	mpAlarmXlist();
	MpAlarmXCore_0();
	MpAlarmXHistory_0();
END_PROGRAM
