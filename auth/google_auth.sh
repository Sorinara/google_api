#!/bin/bash

. ./Google_Auth.sh

DEFAULT_BROWSER_NAME='google-chrome'

function Usage()
{
    echo '-i : client id'
    echo '-s : client secret'
    echo '-S : scope'
    echo '-r : refresh token (if you not insert refresh token, try new register key)'
    echo '     - renew token, EXIST TOKEN DO NOT USE'
    echo '-b : web browser name (only use register token)'
    echo '-o : output filepath'
    echo '--------------------------'
    echo 'First of all, regitster client id, client secret'
    echo 'client id, client secret is setting to here (You must have google account)'
    echo 'https://code.google.com/apis/console -> API Access -> Create Another Client ID -> Application Type -> Installed application'
}

while getopts "i:s:S:r:b:o:" Option;do
    case $Option in 
        i )
            CLIENT_ID="$OPTARG"
            ;;
        s )
            # google calendar client (Register url : https://code.google.com/apis/console must be "INSTALLED APPLICATIONS" )
            CLIENT_SECRET="$OPTARG"
            ;;
        S )
            SCOPE="$OPTARG"
            ;;
        r )
            REFRESH_TOKEN="$OPTARG"
            ;;
        b )
            BROWSER_NAME="$OPTARG"
            ;;
        o )
            OUTPUT_FILEPATH="$OPTARG"
            ;;
    esac
done

if [ -z "$BROWSER_NAME" ];then
    BROWSER_NAME="$DEFAULT_BROWSER_NAME"
fi

Google_Auth "$CLIENT_ID" "$CLIENT_SECRET" "$SCOPE" "$REFRESH_TOKEN" "$BROWSER_NAME" 
case $? in
    0)
        echo ">Token            :"$GOOGLE_AUTH_RETURN_TOKEN""          | tee "$OUTPUT_FILEPATH" 2>/dev/null
        echo ">Refresh token    :"$GOOGLE_AUTH_RETURN_TOKEN_REFRESH""  | tee "$OUTPUT_FILEPATH" 2>/dev/null
        echo ">Type             :"$GOOGLE_AUTH_RETURN_TOKEN_TYPE""     | tee "$OUTPUT_FILEPATH" 2>/dev/null
        ;;
    1 )
        echo 'please add this option -c(client id), -s(client secret), -S(scope)'
        Usage
        exit 1
        ;;
    2 )
        echo 'Auth Error : Donot know user code'
        exit 2
        ;;
    3 )
        echo 'Auth Error : Donot know device code'
        exit 3
        ;;
esac

# example
# # google calendar scope (Reference url : https://developers.google.com/google-apps/calendar/auth)
# SCOPE="https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/calendar.readonly"
# 토큰은 새로 인증할때마다 바뀌니 주의할것
# google_auth.sh -i '60795773340-ovghntmh9fbegh73mcn3dihoin4nhv1q.apps.googleusercontent.com' -s 'CU1_L7daOSbPrKrLc3fxvDOq' -S "https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/calendar.readonly"
