#!/bin/bash

. ./Google_Calendar.sh

unset REQUIRE_OPTION_LINE
unset LONG_OPTION_LINE
PARAM_DELIMITER='
'
PARAMS="$(getopt -o 't:T:j:J:R:M:c:e:r:s:' -l 'token:,\
                                               token-type:,\
                                               json-send-filepath:,\
                                               json-recive-filepath:,\
                                               resource:,\
                                               method:,\
                                               calendar-id,\
                                               event-id,\
                                               rule-id,\
                                               setting,\
                                               always-include-email:,\
                                               color-rgb-format:,\
                                               min-access-role:,\
                                               max-attendees:,\
                                               max-result:,\
                                               original-start:,\
                                               page-token:,\
                                               send-notifications:,\
                                               show-hidden:,\
                                               show-deleted:,\
                                               show-hidden-invitations:,\
                                               single-event:,\
                                               time-max:,\
                                               time-min:,\
                                               time-zone:,\
                                               update-min:' --name "$0" -- "$@")"

REQUIRE_OPTION_INDEX=0
LONG_OPTION_INDEX=0

eval set -- "$PARAMS"

while true;do
    OPTARG="$2"
    OPTION="$1"

    case $OPTION in
        -t | --token )
            TOKEN="$OPTARG"
            ;;
        # send, recive json filepath
        -j | --json-send-filepath )
            JSON_SEND_FILEPATH="$OPTARG"
            if [ ! -f "$JSON_SEND_FILEPATH" ];then
                echo 'Not Exist Json file'
                exit 1
            fi
            ;;
        -J | --json-recive-filepath )
            JSON_RECIVE_FILEPATH="$OPTARG"
            ;;
        # -R(resource), -M(Method) Send Type
        -R | --resource )
            case "$OPTARG" in
                acl | calendarlist | calendar | color | event | freebusy | settings )
                    RESOURCE_TYPE="$OPTARG"
                    ;;
                * )
                    echo 'invalid resource option'
                    echo 'resource option : acl, calendarlist, calendar, color, event, freebusy, settings'
                    exit 1
                    ;;
            esac
            ;;
        -M | --method )
            case "$OPTARG" in
                delete | get | insert | list | update | patch | clear | import | instances | move | quickadd )
                    METHOD_NAME="$OPTARG"
                    ;;
                * )
                    echo 'invalid method option'
                    echo 'method option : delete, get, insert, list, update, patch, clear, import, instances, move, quickadd'
                    exit 1
                    ;;
            esac
            ;;
        # -c, -e, -r, -s is REQURE
        -c | --calendar-id )
            REQUIRE_OPTION_NAME[$REQUIRE_OPTION_INDEX]='calendarId'
            REQUIRE_OPTION_LINE=""$REQUIRE_OPTION_LINE""$OPTARG""$PARAM_DELIMITER""
            REQUIRE_OPTION_INDEX=$(($REQUIRE_OPTION_INDEX + 1))
            ;;
        -e | --event-id )
            REQUIRE_OPTION_NAME[$REQUIRE_OPTION_INDEX]='eventId'
            REQUIRE_OPTION_LINE=""$REQUIRE_OPTION_LINE""$OPTARG""$PARAM_DELIMITER""
            REQUIRE_OPTION_INDEX=$(($REQUIRE_OPTION_INDEX + 1))
            ;;
        -r | --rule-id )
            REQUIRE_OPTION_NAME[$REQUIRE_OPTION_INDEX]='ruldId'
            REQUIRE_OPTION_LINE=""$REQUIRE_OPTION_LINE""$OPTARG""$PARAM_DELIMITER""
            REQUIRE_OPTION_INDEX=$(($REQUIRE_OPTION_INDEX + 1))
            ;;
        -s | --setting )
            REQUIRE_OPTION_NAME[$REQUIRE_OPTION_INDEX]='setting'
            REQUIRE_OPTION_LINE=""$REQUIRE_OPTION_LINE""$OPTARG""$PARAM_DELIMITER""
            REQUIRE_OPTION_INDEX=$(($REQUIRE_OPTION_INDEX + 1))
            ;;
        # spacial option is OPTION (--long-options)
        --always-include-email      |\
        --color-rgb-format          |\
        --min-access-role           |\
        --max-attendees             |\
        --max-result                |\
        --original-start            |\
        --page-token                |\
        --send-notifications        |\
        --show-hidden               |\
        --show-deleted              |\
        --show-hidden-invitations   |\
        --single-event              |\
        --time-max                  |\
        --time-min                  |\
        --time-zone                 |\
        --update-min )
            # --max-result => MaxResult
            # 1, delete '--'
            # 2, -[a-z] => '[A-Z]'
            LONG_OPTION_NAME[$LONG_OPTION_INDEX]="$(echo "${OPTION:2}" | perl -pe 's/(-[a-z])/\U\1\E/g,s/-//g')"
            LONG_OPTION_LINE=""$LONG_OPTION_LINE""$OPTARG""$PARAM_DELIMITER""
            LONG_OPTION_INDEX=$(($LONG_OPTION_INDEX + 1))
            ;;
        -- )
            break
            ;;
        * )
            echo 'invalid option'
            exit 1
            ;;
    esac
    # 모든 인자는 parametor를 필요로함
    shift 2 
done

# 토큰을 가지고 온다
if [ -z "$TOKEN" ];then
    echo 'require -t(token) options'
    exit 2
fi

if [ -z "$RESOURCE_TYPE" ] || [ -z "$METHOD_NAME" ];then
    echo 'require -R(resoure), -M(method) options'
    exit 3
fi

if [ -z "$JSON_RECIVE_FILEPATH" ];then
    echo 'require -J(recive) options'
    exit 3
fi

Google_Calendar_Json_Get "$TOKEN" "$RESOURCE_TYPE" "$METHOD_NAME" "${REQUIRE_OPTION_NAME[*]}" "${REQUIRE_OPTION_LINE[*]}" "${LONG_OPTION_NAME[*]}" "${LONG_OPTION_LINE[*]}" "$JSON_SEND_FILEPATH" "$JSON_RECIVE_FILEPATH"
case $? in 
    1 )
        echo 'Get Query URL Error, check options please'
        return 1
        ;;
    2 )
        echo 'Create Url, Failed'
        return 2
        ;;
    3 )
        echo 'Url type Error, check -r(resource), -m(method) options'
        return 3
        ;;
esac

#./calendar_auth.sh -t 'ya29.AHES6ZTbFYnuDG_xxbLVfQFV2Gs-pI_JXjRfyyvOGmw8eUg' -u 'https://www.googleapis.com/calendar/v3/users/me/calendarList'
# example
# Token 값은 재 인증시 변경되므로 주의할것
# ./calendar_messenger.sh -t 'ya29.AHES6ZRjPXS4b8bSX1QbH5zgBc3PgzfU7lTFwacjI7DdieU' -T 'Bearer' -R event -M list -c 'uusumsslinfipjm67208umf460@group.calendar.google.com'
