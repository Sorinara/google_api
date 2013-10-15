#!/bin/bash

NEW_LINE='
'

# name 은 array로 받고,
# param은 line-string으로 받아서 파싱(param에는 공백이 포함될 수도 있으므로)
function Option_Paramiter_Divider()
{
    local Name=( $1 )
    local Old_IFS="$IFS"
    IFS="$NEW_LINE"
    local Param=( $2 )
    IFS="$Old_IFS"
    local Before_string="$3"
    local After_string="$4"
    local Count=0
    local Return_string=""
    unset OPTION_PARAMETER_DEVIDER_RETURN
 
    while [ $Count -lt ${#Name[@]} ];do
        if [ "${Param[$Count]:0:1}" = ' ' ];then
            Param[$Count]="${Param[$Count]:1}"
        fi

        Return_string="$Return_string""$Before_string""${Name[$Count]}"'='"${Param[$Count]}""$After_string"
        Count=$(($Count + 1))
    done

    OPTION_PARAMETER_DEVIDER_RETURN="$Return_string"
}

function HTTP_Header_Creator()
{
    local Type="$1"
    local Parameter="$2"

    HTTP_HEADER_CREATOR_RETURN="$Type"': '"$Parameter"
}

function Url_Request_Type_Get()
{
    local Method="$1"
    local Http_command=""
    unset URL_REQUEST_TYPE_GET_RETURN

    case "$Method" in
        delete )
            Http_command='DELETE'
            ;;
        get | list | instances )
            Http_command='GET'
            ;;
        insert | clear | import | move | quickadd | query )
            Http_command='POST'
            ;;
        update )
            Http_command='PUT'
            ;;
        patch )
            Http_command='PATCH'
            ;;
        * )
            return 1
    esac

    URL_REQUEST_TYPE_GET_RETURN="$Http_command"
    return 0
}

function Url_Require_Resource_ACL()
{
    local Base_url="$1"
    local Method="$2"
    local Calendar_id="$3"
    local Rule_id="$4"
    local Acl_common_url='/calendars/'"$Calendar_id"'/acl'
    local Acl_option_url='/'"$Rule_id"
    local Url="$Base_url"
    unset URL_REQUIRE_RESOURCE_ACL_GET_RETURN

    if [ -z "$Calendar_id" ];then
        return 1
    fi

    case "$Method" in 
        delete )
            if [ -z "$Rule_id" ];then
                return 2
            fi
            Url="$Url""$Acl_common_url""$Acl_option_url"
            ;;
        get )
            if [ -z "$Rule_id" ];then
                return 2
            fi
            Url="$Url""$Acl_common_url""$Acl_option_url"
            ;;
        insert )
            Url="$Url""$Acl_common_url"
            ;;
        list )
            Url="$Url""$Acl_common_url"
            ;;
        patch )
            if [ -z "$Rule_id" ];then
                return 2
            fi
            Url="$Url""$Acl_common_url""$Acl_option_url"
            ;;
        update )
            if [ -z "$Rule_id" ];then
                return 2
            fi
            Url="$Url""$Acl_common_url""$Acl_option_url"
            ;;
        * )
            return 3
    esac

    URL_REQUIRE_RESOURCE_ACL_GET_RETURN="$Url"
    return 0
}

function Url_Require_Resource_CalendarList()
{
    local Base_url="$1"
    local Method="$2"
    local Calendar_id="$3"
    local Calendar_list_common_url='/users/me/calendarList'
    local Calendar_list_option_url='/'"$Calendar_id"
    local Url="$Base_url"
    unset URL_Require_RESOURCE_CALENDARLIST_RETURN

    case "$Method" in 
        delete )
            if [ -z "$Calendar_id" ];then
                return 1
            fi
            Url="$Url""$Calendar_list_common_url""$Calendar_list_option_url"
            ;;
        get )
            if [ -z "$Calendar_id" ];then
                return 1
            fi
            Url="$Url""$Calendar_list_common_url""$Calendar_list_option_url"
            ;;
        insert )
            Url="$Url""$Calendar_list_common_url"
            ;;
        list )
            Url="$Url""$Calendar_list_common_url"
            ;;
        patch )
            if [ -z "$Calendar_id" ];then
                return 1
            fi
            Url="$Url""$Calendar_list_common_url""$Calendar_list_option_url"
            ;;
        update )
            if [ -z "$Calendar_id" ];then
                return 1
            fi
            Url="$Url""$Calendar_list_common_url""$Calendar_list_option_url"
            ;;
        * )
            return 2
            ;;
    esac

    URL_REQUIRE_RESOURCE_CALENDARLIST_RETURN="$Url"
    return 0
}

function Url_Require_Resource_Calendar()
{
    local Base_url="$1"
    local Method="$2"
    local Calendar_id="$3"
    local Calendars_common_url='/calendars'
    local Calendars_option_url='/'"$Calendar_id"
    local Url="$Base_url"
    unset URL_REQUIRE_RESOURCE_CALENDAR_RETURN

    case "$Method" in
        delete )
            if [ -z "$Calendar_id" ];then
                return 1
            fi
            Url="$Url""$Calendars_common_url""$Calendars_option_url"
            ;;
        get )
            if [ -z "$Calendar_id" ];then
                return 1
            fi
            Url="$Url""$Calendars_common_url""$Calendars_option_url"
            ;;
        insert )
            Url="$Url""$Calendars_common_url"
            ;;
        patch )
            if [ -z "$Calendar_id" ];then
                return 1
            fi
            Url="$Url""$Calendars_common_url""$Calendars_option_url"
            ;;
        update )
            if [ -z "$Calendar_id" ];then
                return 1
            fi
            Url="$Url""$Calendars_common_url""$Calendars_option_url"
            ;;
        * )
            return 2
            ;;
    esac

    URL_REQUIRE_RESOURCE_CALENDAR_RETURN="$Url"
    return 0
}

function Url_Require_Resource_Color()
{
    local Base_url="$1"
    local Method="$2"
    local Colors_common_url='/colors'
    local Url="$Base_url"
    unset URL_Require_RESOURCE_COLOR_RETURN

    case "$Method" in
        get )
            Url="$Url""$Colors_common_url"
            ;;
        * )
            return 1
            ;;
    esac

    URL_REQUIRE_RESOURCE_COLOR_RETURN="$Url"
    return 0
}

function Url_Require_Resource_Event()
{
    local Base_url="$1"
    local Method="$2"
    local Calendar_id="$3"
    local Event_id="$4"
    local Additional_parameter="$5"
    local Events_common_url='/calendars/'"$Calendar_id"'/events'
    local Events_option_url='/'"$Event_id"
    local Url="$Base_url"
    unset URL_REQUIRE_RESOURCE_EVENT_RETURN

    if [ -z "$Calendar_id" ];then
        return 1
    fi

    case "$Method" in
        delete )
            if [ -z "$Event_id" ];then
                return 2
            fi
            Url="$Url""$Events_common_url""$Events_option_url"
            ;;
        get )
            if [ -z "$Event_id" ];then
                return 2
            fi
            Url="$Url""$Events_common_url""$Events_option_url"
            ;;
        import )
            Url="$Url""$Events_common_url"
            ;;
        insert )
            Url="$Url""$Events_common_url"
            ;;
        instance )
            if [ -z "$Event_id" ];then
                return 2
            fi
            Url="$Url""$Events_common_url""$Events_option_url"
            ;;
        list )
            Url="$Url""$Events_common_url"
            ;;
        move )
            if [ -z "$Event_id" ];then
                return 2
            fi
            Url="$Url""$Events_common_url""$Events_option_url"'/move?destination='"$Additional_parameter"
            ;;
        patch )
            if [ -z "$Event_id" ];then
                return 2
            fi
            Url="$Url""$Events_common_url""$Events_option_url"
            ;;
        quickdd )
            if [ -z "$Event_id" ];then
                return 2
            fi
            Url="$Url""$Events_common_url""$Events_option_url"'/quickAdd?text='"$Additional_parameter"
            ;;
        update )
            if [ -z "$Event_id" ];then
                return 2
            fi
            Url="$Url""$Events_common_url""$Events_option_url"
            ;;
        * )
            return 3
            ;;
    esac

    URL_REQUIRE_RESOURCE_EVENT_RETURN="$Url"
    return 0
}

function Url_Require_Resource_FreeBusy()
{
    local Base_url="$1"
    local Method="$2"
    local Freebusy_common_url='/freebusy'
    local Url="$Base_url"
    unset URL_REQUIRE_RESOURCE_FREEBUSY_RETURN

    case "$Method" in
        query )
            Url="$Url""$Freebusy_common_url"
            ;;
        * )
            return 1
    esac

    URL_REQUIRE_RESOURCE_FREEBUSY_RETURN="$Url"
    return 0
}

function Url_Require_Resource_Setting()
{
    local Base_url="$1"
    local Method="$2"
    local Setting="$3"
    local Settings_common_url='/users/me/settings'
    local Settings_option_url='/'"$Setting"
    local Url="$Base_url"
    unset URL_REQUIRE_RESOURCE_SETTING_RETURN

    case "$Method" in
        get )
            if [ -z "$Setting" ];then
                return 1
            fi
            Url="$Url""$Settings_common_url""$Settings_option_url"
            ;;
        list )
            Url="$Url""$Settings_common_url"
            ;;
        * )
            return 2
    esac

    URL_REQUIRE_RESOURCE_SETTING_RETURN="$Url"
    return 0
}

function Url_Base_Get()
{
    local Resource_type="$1"
    local Method="$2"
    local Require_name_list="$3"
    local Require_data_list="$4"
    local Require_name_array=""
    local Require_data_array=""
    local Option_name=""
    local Option_param=""
    local Calendar_id=""
    local Event_id=""
    local Rule_id=""
    local Additional_parameter=""
    local Count=0
    local Old_IFS=""
    local Base_url='https://www.googleapis.com/calendar/v3'
    local Url=""
    local Return_value=0
    unset URL_BASE_GET_RETURN

    Require_name_array=( $Require_name_list )
    Old_IFS="$IFS"
    IFS="$NEW_LINE"
    Require_data_array=( $Require_data_list )
    IFS="$Old_IFS"

    while [ $Count -lt ${#Require_name_array[@]} ];do
        Option_name="${Require_name_array[$Count]}"
        Option_param="${Require_data_array[$Count]}"

        # Array[*]로 다 가져왔을때는 ' '(space delimiter)도
        # 덩달아 붙으므로 따로 빼줘야 한다.
        if [ "${Option_param:0:1}" = ' ' ];then
            Option_param=${Option_param:1}
        fi

        # Normal - 자주쓰는 파리미터들
        case $Option_name in 
            calendarId )
                Calendar_id="$Option_param"
                ;;
            eventId )
                Event_id="$Option_param"
                ;;
            ruldId )
                Rule_id="$Option_param"
                ;;
        esac

        # for (only)event
        case $Option_name in 
            destination )
                Additional_parameter="$Option_param"
                ;;
            text )
                Additional_parameter="$Option_param"
                ;;
        esac

        # for (only)setting
        case $Option_name in 
            setting )
                Additional_parameter="$Option_param"
                ;;
        esac
        Count=$(($Count + 1))
    done

    case "$Resource_type" in 
        acl )
            Url_Require_Resource_ACL "$Base_url" "$Method" "$Calendar_id" "$Rule_id"
            Return_value=$?
            Url="$URL_REQUIRE_RESOURCE_ACL_GET_RETURN"
            ;;
        calendarlist )
            Url_Require_Resource_CalendarList "$Base_url" "$Method" "$Calendar_id"
            Return_value=$?
            Url="$URL_REQUIRE_RESOURCE_CALENDARLIST_RETURN"
            ;;
        calendar )
            Url_Require_Resource_Calendar "$Base_url" "$Method" "$Calendar_id"
            Return_value=$?
            Url="$URL_REQUIRE_RESOURCE_CALENDAR_RETURN"
            ;;
        color )
            Url_Require_Resource_Color "$Base_url" "$Method"
            Return_value=$?
            Url="$URL_REQUIRE_RESOURCE_COLOR_RETURN"
            ;;
        event )
            Url_Require_Resource_Event "$Base_url" "$Method" "$Calendar_id" "$Event_id" "$Additional_parameter"
            Return_value=$?
            Url="$URL_REQUIRE_RESOURCE_EVENT_RETURN"
            ;;
        freebusy )
            Url_Require_Resource_FreeBusy "$Base_url" "$Method"
            Return_value=$?
            Url="$URL_REQUIRE_RESOURCE_FREEBUSY_RETURN"
            ;;
        settings )
            Url_Require_Resource_Setting "$Base_url" "$Method" "$Additional_parameter"
            Return_value=$?
            Url="$URL_REQUIRE_RESOURCE_SETTING_RETURN"
            ;;
    esac

    if [ $Return_value != 0 ];then
        return 1
    fi

    URL_BASE_GET_RETURN="$Url"
    return 0
}

# Json Body가 있는지 검사
function Url_Parameter_Check()
{
    local Method="$1"
    local Json_filepath="$2"
    unset URL_DATA_CHECK_RETURN

    # Resource_type과는 상관이 없다
    case "$Method" in 
        delete | get | list | clear | instance | move | quickadd )
            return 0
            ;;
        insert | update | patch | import | insert | query )
            URL_DATA_CHECK_RETURN="$(cat "$Json_filepath" | tr -d '\n')"
            if [ -z "$URL_DATA_CHECK_RETURN" ];then
                return 2
            fi
            return 1
            ;;
        * )
            return 3
            ;;
    esac
    return 4
}

function Url_Encode_Get()
{
    local Url_array="$1"
    local Url_delimiter='%0A' 
    local Target_delimiter='\n'
    local Perl_delimiter='+'
    local Encode_string=""
    local Url_array_line=""
    unset URL_ENCODE_GET_RETURN

    if [ "$Target_delimiter" = "$Perl_delimiter" ];then
        Perl_delimiter='@'
    fi

    # Url 인코딩이 되는 문자는 16진수여야 한다
    case "$Url_delimiter" in 
        '%'[0-9a-fA-F][0-9a-fA-F] )
            ;;
        * )
            return 1
            ;;
    esac

    # Array를 통채로 다 보여주면, $Url_array인자는 array타입이 아니지만,
    # 이전에 ${Array[@]} 형식으로 넘어왔기 때문에,
    # 전체를 다 출력하면 각 인자의 delimiter인 ' '가 출력된다.
    # 그래서 일단 공백을 지우고. ('\n' 구분자는 존재하는 상태)
    Url_array_line="$(echo "$Url_array" | tr -d ' ')"

    # Url 인코딩을 실행
    Encode_string="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$Url_array_line" )"

    # Url 인코딩을 하면 (${Url_array[@]}의 실제 구분자인 '\n'도 인코딩 되어버리기
    # 때문에, 이를(%0A)를 다시 실재 개행문자('\n')로 되돌려 놓아야만 한다.
    URL_ENCODE_GET_RETURN="$(echo "$Encode_string" | perl -pe 's'"$Perl_delimiter""$Url_delimiter""$Perl_delimiter""$Target_delimiter""$Perl_delimiter"'g')"
    return 0
}

function Url_Parameter_Get()
{
    local Name_array="$1"
    local Data_array="$2"
    local Url_parameter=""
    local Parameter_delimiter='&'
    unset URL_PARAMETER_GET_RETURN_PARAM

    if [ -z "$Name_array" ] || [ -z "$Data_array" ];then
        return 1
    fi

    # "?Name=data"형식으로 파라미터들을 한줄로 정리
    Option_Paramiter_Divider "$Name_array" "$Data_array" '' "$Parameter_delimiter"
    Url_parameter="$OPTION_PARAMETER_DEVIDER_RETURN"

    URL_PARAMETER_GET_RETURN_PARAM="$Url_parameter"
    return 0
}

function Url_Get()
{
    local Json_filepath="$1"
    local Resource_type="$2"
    local Method_name="$3"
    local Require_name_array="$4"
    local Require_data_array="$5"
    local Option_name_array="$6"
    local Option_data_array="$7"
    local Request_type=""
    local Require_data_encode_array=""
    local Url_base=""
    local Option_data_encode_array=""
    local Url_parameter=""
    local Url=""
    local Url_parameter_delimiter='?'
    unset URL_GET_RETURN_URL
    unset URL_GET_RETURN_REQUEST_TYPE

    # POST, GET, DELETE 같은 타입을 정한다
    Url_Request_Type_Get "$Method_name"
    if [ $? != 0 ];then
        return 1
    fi

    Request_type="$URL_REQUEST_TYPE_GET_RETURN"

    # Url에 꼭 필요한 요소가 모두 있는지 확인한다.
    Url_Parameter_Check "$Method_name" "$Json_filepath"
    if [ $? -gt 2 ];then
        return 2
    fi

    Url_Encode_Get "$Require_data_array"
    Require_data_encode_array="$URL_ENCODE_GET_RETURN"

    # base 소를 만든다
    Url_Base_Get "$Resource_type" "$Method_name" "$Require_name_array" "$Require_data_encode_array"
    if [ $? != 0 ];then
        return 3
    fi

    Url_base="$URL_BASE_GET_RETURN"

    # 여기선 array때문에 생기는 공백을 없애야함(왜냐하면 구분자가 '\n'가 되어야하기 때문)
    Url_Encode_Get "$Option_data_array"
    Option_data_encode_array="$URL_ENCODE_GET_RETURN"

    Url_Parameter_Get "$Option_name_array" "$Option_data_encode_array"
    Url_parameter="$URL_PARAMETER_GET_RETURN_PARAM"

    # $Url_parameter_delimiter '?'는 실제로 파라미터가 있을때에만 동작해야 함
    if [ -n "$Url_parameter" ];then
        Url_parameter="$Url_parameter_delimiter""$Url_parameter"
    fi

    Url="$Url_base""$Url_parameter"

    URL_GET_RETURN_URL="$Url"
    URL_GET_RETURN_REQUEST_TYPE="$Request_type"
    return 0
}

function Google_Calendar_Send()
{
    local Url="$1"
    local Request_type="$2"
    local Authorization="$3"
    local Content_type="$4"
    local Content_length="$5"
    local Send_filepath="$6"
    local Recive_filepath="$7"
    local Send_option=""
    local Recive_option=""

    # 바이트로 넣어야함... 문자열 길이가 아냐! (ParseError의 원인)
    if [ -f "$Send_filepath" ] && [ -s "$Send_filepath" ];then
        Send_option='--data-binary @'"$Send_filepath"
    fi
    
    if [ -n "$Recive_filepath" ];then
        Recive_option='-o '"$Recive_filepath"
    fi

    curl -s -X "$Request_type" -H "$Authorization" \
                               -H "$Content_type" \
                               -H "$Content_length" \
                               "$Url" \
                               $Send_option \
                               $Recive_option >/dev/null

    return $?
}

function Google_Calendar_Header_Get()
{
    local Token="$1"
    local Url="$2"
    local Request_type="$3"
    local Send_filepath="$4"
    local Url_parameter_name=""
    local Send_file_size=0
    local Header_content_length=""
    local Header_content_type=""
    local Header_authorization=""
    local Google_token_type='Bearer'
    unset GOOGLE_CALENDAR_HEADER_GET_RETURN_HEADER_CONTENT_LENGTH
    unset GOOGLE_CALENDAR_HEADER_GET_RETURN_HEADER_CONTENT_TYPE
    unset GOOGLE_CALENDAR_HEADER_GET_RETURN_HEADER_AUTHORIZATION

    Url_parameter_name="$(echo "$Url" | cut -d '?' -f2 | cut -d '=' -f1)"

    # cut은 delimiter가 없을때 출력된거 그대로 내보내버린다.
    # 그래서 원래 문자열과 같은지 검사하는것
    if [ "$Url_parameter_name" != "$Url" ] && \
       [ -n "$Url_parameter_name" ] && [ "$Request_type" = "POST" ];then
        Send_file_size="$(du -b "$Send_filepath" 2>/dev/null)"

        if [ -z "$Send_file_size" ];then
            Send_file_size=0
        fi

        HTTP_Header_Creator "Content-length" "$Send_file_size"
        Header_content_length="$HTTP_HEADER_CREATOR_RETURN"
    fi

    # 이것도 빼먹으면 안됨!
    HTTP_Header_Creator "Content-type" "application/json"
    Header_content_type="$HTTP_HEADER_CREATOR_RETURN"

    # Auth할 Header를 합성
    HTTP_Header_Creator "Authorization" ""$Google_token_type" "$Token""
    Header_authorization="$HTTP_HEADER_CREATOR_RETURN"

    GOOGLE_CALENDAR_HEADER_GET_RETURN_HEADER_CONTENT_LENGTH="$Header_content_length"
    GOOGLE_CALENDAR_HEADER_GET_RETURN_HEADER_CONTENT_TYPE="$Header_content_type"
    GOOGLE_CALENDAR_HEADER_GET_RETURN_HEADER_AUTHORIZATION="$Header_authorization"
}

function Google_Calendar_Json_Get()
{
    local Token="$1"
    local Resource_type="$2"
    local Method_name="$3"
    local Url_require_name_array="$4"
    local Url_require_data_array="$5"
    local Url_option_name_array="$6"
    local Url_option_data_array="$7"
    local Json_send_filepath="$8"
    local Json_recive_filepath="$9"
    local Return_value=0
    local Url=""
    local Http_request=""
    local Header_authorization=""
    local Header_content_type=""
    local Header_content_length=""

    # 여기서 Url가공/인코딩이 모두 이뤄집니다!
    Url_Get "$Json_send_filepath" "$Resource_type" "$Method_name" "$Url_require_name_array" "$Url_require_data_array" "$Url_option_name_array" "$Url_option_data_array"
    Return_value=$?
    if [ $Return_value != 0 ];then
        # return value is 1 ~ 3 #echo $Return_value
        return 1
    fi
    
    # 이미 인코딩이 되어 있는 URL임
    Url="$URL_GET_RETURN_URL"
    Http_request="$URL_GET_RETURN_REQUEST_TYPE"

    # TODO: url파라미터에 추가문자열이 들어감 + http request가 POST
    # 이 두조건이 모두 만족하면, content-length 헤더가 추가되어야 함!
    # (이 상황이 아니면 따로 content-length를 추가하면 안됨!)
    Google_Calendar_Header_Get "$Token" "$Url" "$Http_request" "$Json_send_filepath"
    Header_authorization="$GOOGLE_CALENDAR_HEADER_GET_RETURN_HEADER_AUTHORIZATION"
    Header_content_type="$GOOGLE_CALENDAR_HEADER_GET_RETURN_HEADER_CONTENT_TYPE"
    Header_content_length="$GOOGLE_CALENDAR_HEADER_GET_RETURN_HEADER_CONTENT_LENGTH"

    Google_Calendar_Send "$Url" "$Http_request" "$Header_authorization" "$Header_content_type" "$Header_content_length" "$Json_send_filepath" "$Json_recive_filepath"
    if [ $? != 0 ];then
        return 2
    fi

    return 0
}

function Google_Calendar_Header_Batch_Main_Get()
{
    local Token="$1"
    local Batch_separate_string="$2"
    local Google_token_type='Bearer'
    local Request_type="POST"
    local Url='https://www.googleapis.com/batch'
    local Batch_separate_line='--'"$Batch_separate_string"
    local Content_type="multipart/mixed; boundary="$Batch_separate_string""
    local Header_content_type=""
    local Header_authorization=""
    unset GOOGLE_CALENDAR_BATCH_HEADER_GET_RETURN_HEADER_REQUEST_TYPE
    unset GOOGLE_CALENDAR_BATCH_HEADER_GET_RETURN_HEADER_URL
    unset GOOGLE_CALENDAR_BATCH_HEADER_GET_RETURN_HEADER_CONTENT_TYPE
    unset GOOGLE_CALENDAR_BATCH_HEADER_GET_RETURN_HEADER_AUTHORIZATION
    unset GOOGLE_CALENDAR_BATCH_HEADER_GET_RETURN_HEADER_SEPRATE_LINE

    # 이것도 빼먹으면 안됨!
    HTTP_Header_Creator "Content-type" "$Content_type"
    Header_content_type="$HTTP_HEADER_CREATOR_RETURN"

    # Auth할 Header를 합성
    HTTP_Header_Creator "Authorization" ""$Google_token_type" "$Token""
    Header_authorization="$HTTP_HEADER_CREATOR_RETURN"

    GOOGLE_CALENDAR_BATCH_HEADER_GET_RETURN_HEADER_REQUEST_TYPE="$Request_type"
    GOOGLE_CALENDAR_BATCH_HEADER_GET_RETURN_HEADER_URL="$Url"
    GOOGLE_CALENDAR_BATCH_HEADER_GET_RETURN_HEADER_CONTENT_TYPE="$Header_content_type"
    GOOGLE_CALENDAR_BATCH_HEADER_GET_RETURN_HEADER_AUTHORIZATION="$Header_authorization"
    GOOGLE_CALENDAR_BATCH_HEADER_GET_RETURN_HEADER_SEPRATE_LINE="$Batch_separate_line"
}

function Google_Calendar_Header_Batch_Sub_Get()
{
    local Content_type='application/http'
    local Header_content_type=""
    unset GOOGLE_CALENDAR_HEADER_BATCH_SUB_GET_RETURN_CONTENT_TYPE

    # 이것도 빼먹으면 안됨!
    HTTP_Header_Creator "Content-type" "$Content_type"
    Header_content_type="$HTTP_HEADER_CREATOR_RETURN"

    GOOGLE_CALENDAR_HEADER_BATCH_SUB_GET_RETURN_CONTENT_TYPE="$Header_content_type"
}

function Google_Calendar_Batch()
{
    local Batch_separate_line="$1"
    local Resource_type="$2"
    local Method_name="$3"
    local Url_require_name_array="$4"
    local Url_require_data_array="$5"
    local Url_option_name_array="$6"
    local Url_option_data_array="$7"
    local Batch_data_filepath="$8"
    local Json_send_filepath="$9"
    local Return_value=0
    local Url=""
    local Http_request=""
    local Header_content_type=""

    # 여기서 Url가공/인코딩이 모두 이뤄집니다!
    Url_Get "$Json_send_filepath" "$Resource_type" "$Method_name" "$Url_require_name_array" "$Url_require_data_array" "$Url_option_name_array" "$Url_option_data_array"
    Return_value=$?
    if [ $Return_value != 0 ];then
        # return value is 1 ~ 3 ;
        return $Return_value
    fi
    
    # 이미 인코딩이 되어 있는 URL임
    Url="$URL_GET_RETURN_URL"
    Http_request="$URL_GET_RETURN_REQUEST_TYPE"

    Google_Calendar_Header_Batch_Sub_Get
    Header_content_type="$GOOGLE_CALENDAR_HEADER_BATCH_SUB_GET_RETURN_CONTENT_TYPE"

    echo "$Header_content_type"    >> "$Batch_data_filepath"
    echo                           >> "$Batch_data_filepath"
    echo "$Http_request"' '"$Url"  >> "$Batch_data_filepath"
    echo "$Batch_separate_line"    >> "$Batch_data_filepath" 
    return 0
}
# Main HTTP
# 1, Request Type        : (static) POST
# 2, Url                 : (static) https://www.googleapis.com/batch
# 3, Content-Type Header : (static) Content-type: multipart/mixed; boundary=batch_delimiter (boundary이후의 값은 user define)
# 4, Auth header         : (static) Authorization: OAuth ya29.AHES6ZTJbxe0htHggcnGVRwxb1Puqsv7OKb1-PNZuEu0DuUzzWzodg
# 5, 각 구분자는 Content-Type의  boundary의 값에 따름(헤더를 구별할떄 마다 해당 문자열을 넣어줘야함)
#
# Sub HTTP (Content-Type이 고정이라는 사실을 뺴면 일반 request와 같다)
# 1, Request Type        : User define
# 2, Url                 : User define
# 3, Content-Type Header : Content-Type: application/http
# 
# Delimiter
# 1, 각 헤더는 "--batch_delimiter"로 구별해 준다(큰따옴표 제외)
# 2, 요청데이터의 가장 앞, 가장 뒤,에도 "--batch_delimiter"가 들어가야 한다.
