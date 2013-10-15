#!/bin/bash

# simple...
function Json_Field_Get()
{
    local Json_filepath="$1"
    local Field_name="$2"
    unset JSON_FIELD_GET_RETURN

    JSON_FIELD_GET_RETURN="$(cat "$Json_filepath" | fgrep '"'"$Field_name"'"' | cut -d '"' -f4)"
}

function Google_Auth_Curl_Get()
{
    local Url="$1"
    local Query_string="$2"
    local Result_filepath="$3"

    curl -s -d "$Query_string" "$Url" > "$Result_filepath"
}

function Google_Auth_Token_Refresh()
{
    local Client_id="$1" 
    local Client_secret="$2"
    local Refresh_token="$3"
    local Auth_url='https://accounts.google.com/o/oauth2/token'
    local Query_string="refresh_token="$Refresh_token"&client_id=""$Client_id""&client_secret="$Client_secret"&grant_type=refresh_token" 
    local Result_filepath="/tmp/google_api_token_refresh_$$"
    unset GOOGLE_AUTH_TOKEN_REFRESH_RETURN_TOKEN
    unset GOOGLE_AUTH_TOKEN_REFRESH_RETURN_TYPE
    unset GOOGLE_AUTH_TOKEN_REFRESH_RETURN_EXPIRE_SECOND

    # Get refresh token
    Google_Auth_Curl_Get "$Auth_url" "$Query_string" "$Result_filepath"

    Json_Field_Get "$Result_filepath" "access_token"
    GOOGLE_AUTH_TOKEN_REFRESH_RETURN_TOKEN="$JSON_FIELD_GET_RETURN"

    Json_Field_Get "$Result_filepath" "token_type"
    GOOGLE_AUTH_TOKEN_REFRESH_RETURN_TYPE="$JSON_FIELD_GET_RETURN"

    Json_Field_Get "$Result_filepath" "expires_in"
    GOOGLE_AUTH_TOKEN_REFRESH_RETURN_EXPIRE_SECOND="$JSON_FIELD_GET_RETURN"
    rm -rf "$Result_filepath"
}

function Auth()
{
    local Client_id="$1"
    local Scope="$2"
    local Auth_url='https://accounts.google.com/o/oauth2/device/code' 
    local Query_string="client_id=""$Client_id""&scope="$Scope"" 
    local Result_filepath="/tmp/google_api_auth_$$"
    unset AUTH_RETURN_DEVICE_CODE
    unset AUTH_RETURN_USER_CODE
    unset AUTH_RETURN_VERIFICATION_URL

    # Get user code
    Google_Auth_Curl_Get "$Auth_url" "$Query_string" "$Result_filepath"

    Json_Field_Get "$Result_filepath" "device_code"
    AUTH_RETURN_DEVICE_CODE="$JSON_FIELD_GET_RETURN"

    Json_Field_Get "$Result_filepath" "user_code"
    AUTH_RETURN_USER_CODE="$JSON_FIELD_GET_RETURN"

    Json_Field_Get "$Result_filepath" "verification_url"
    AUTH_RETURN_VERIFICATION_URL="$JSON_FIELD_GET_RETURN"
    rm -rf "$Result_filepath"
}

function Google_Auth_Token_Get()
{
    local Client_id="$1"
    local Client_secret="$2"
    local Device_code="$3"
    local Auth_url='https://accounts.google.com/o/oauth2/token' 
    local Query_string='client_id='"$Client_id"'&client_secret='"$Client_secret"'&code='"$Device_code"'&grant_type=http://oauth.net/grant_type/device/1.0' 
    local Result_filepath="/tmp/google_api_auth_token_$$"
    unset GOOGLE_AUTH_TOKEN_GET_RETURN_TOKEN
    unset GOOGLE_AUTH_TOKEN_GET_RETURN_TYPE
    unset GOOGLE_AUTH_TOKEN_GET_RETURN_TOKEN_REFRESH

    # Get access token
    Google_Auth_Curl_Get "$Auth_url" "$Query_string" "$Result_filepath"

    Json_Field_Get "$Result_filepath" "access_token"
    GOOGLE_AUTH_TOKEN_GET_RETURN_TOKEN="$JSON_FIELD_GET_RETURN"

    Json_Field_Get "$Result_filepath" "token_type"
    GOOGLE_AUTH_TOKEN_GET_RETURN_TYPE="$JSON_FIELD_GET_RETURN"

    Json_Field_Get "$Result_filepath" "refresh_token"
    GOOGLE_AUTH_TOKEN_GET_RETURN_TOKEN_REFRESH="$JSON_FIELD_GET_RETURN"
    rm -rf "$Result_filepath"
}

function Google_Auth()
{
    local Client_id="$1"
    local Client_secret="$2"
    local Scope="$3"
    local Refresh_token="$4"
    local Browser_name="$5"
    local Auth_device_code=""
    local User_input_string=""
    local Verification_url=""
    unset GOOGLE_AUTH_RETURN_TOKEN
    unset GOOGLE_AUTH_RETURN_TOKEN_REFRESH
    unset GOOGLE_AUTH_RETURN_TOKEN_TYPE

    if [ -z "$Client_id" ] || [ -z "$Client_secret" ];then
        return 1
    fi

    if [ -z "$Browser_name" ];then
        Browser_name='google-chrome'
    fi

    if [ -n "$Refresh_token" ];then
        Google_Auth_Token_Refresh "$Client_id" "$Client_secret" "$Refresh_token"
        GOOGLE_AUTH_RETURN_TOKEN="$GOOGLE_AUTH_TOKEN_REFRESH_RETURN_TOKEN"
        GOOGLE_AUTH_RETURN_TOKEN_REFRESH="-"
        GOOGLE_AUTH_RETURN_TOKEN_TYPE="$GOOGLE_AUTH_TOKEN_REFRESH_RETURN_TYPE"
    else
        if [ -z "$Scope" ];then
            return 2
        fi

        Auth "$Client_id" "$Scope"
        Auth_device_code="$AUTH_RETURN_DEVICE_CODE"
        User_input_string="$AUTH_RETURN_USER_CODE"
        Verification_url="$AUTH_RETURN_VERIFICATION_URL"

        if [ -z "$Verification_url" ] || [ -z "$User_input_string" ];then
            return 3
        fi

        if [ -z "$Auth_device_code" ];then
            return 4
        fi

        # Check user code
        echo "User code is "'"'"$User_input_string"'"'
        echo -n 'input user code please. if end, press enter key ...'
        "$Browser_name" "$Verification_url" &
        read

        Google_Auth_Token_Get "$Client_id" "$Client_secret" "$Auth_device_code"
        GOOGLE_AUTH_RETURN_TOKEN="$GOOGLE_AUTH_TOKEN_GET_RETURN_TOKEN"
        GOOGLE_AUTH_RETURN_TOKEN_REFRESH="$GOOGLE_AUTH_TOKEN_GET_RETURN_TOKEN_REFRESH"
        GOOGLE_AUTH_RETURN_TOKEN_TYPE="$GOOGLE_AUTH_TOKEN_GET_RETURN_TYPE"
    fi

    return 0
}
