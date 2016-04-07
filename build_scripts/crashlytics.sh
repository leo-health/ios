while getopts ":k:d:e:t" arg;
do
    case "${arg}" in
        k) #director for stored keys file
        KEYS_DIR=${OPTARG}
        echo "keys directory: ${KEYS_DIR}"
        ;;
        d) #directory of upload script
        UPLOAD_SCRIPT_DIR=${OPTARG}
        echo "upload script directory: ${UPLOAD_SCRIPT_DIR}"
        ;;
        e) #environment
        ENVIRONMENT=${OPTARG}
        echo "environment: ${ENVIRONMENT}"
        ;;
        t) #default option settings
        DEFAULT==1
        ;;
        *) #unknown option or no options
          usage
        ;;
    esac
done
shift $((OPTIND-1))

case ${ENVIRONMENT} in
    qa)
    source "${KEYS_DIR}"/internal_keys.sh
    ;;
    staging)
    source "${KEYS_DIR}"/internal_keys.sh
    ;;
    testflight)
    source "${KEYS_DIR}"/release_keys.sh
    ;;
    appstore)
    source "${KEYS_DIR}"/release_keys.sh
    ;;
    *)
    echo "Development build -- no symbolication necessary."
    exit 0;
    ;;
esac

echo "Running Crashlytics"
"${UPLOAD_SCRIPT_DIR}"/run "${CRASHLYTICS_APP_ID}" "${CRASHLYTICS_BUILD_SECRET}"
