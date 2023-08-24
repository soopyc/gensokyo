// adapted from https://github.com/zedeus/nitter/issues/983#issuecomment-1681199357
// deno run --allow-{env,read,net} nitter-guest-account.js

import axios from 'npm:axios'
import chalk from 'npm:chalk'
const TW_CONSUMER_KEY = '3nVuSoBZnx6U4vzUxf5w'
const TW_CONSUMER_SECRET = 'Bcs59EFbbsdF6Sl9Ng71smgStWEGwXXKSjYvPVt7qys'

const TW_ANDROID_BASIC_TOKEN = `Basic ${btoa(TW_CONSUMER_KEY+':'+TW_CONSUMER_SECRET)}`

const VERBOSE_MODE = Deno.args.includes('-v') || Deno.args.includes("--verbose") || Deno.args.includes('--debug') || Deno.args.includes('-d')
const NO_PRETTYPRINT = Deno.args.includes('-P') || Deno.args.includes("--no-pretty")

function debug(msg) {
    if (VERBOSE_MODE) {
        console.log(chalk.gray(`[*] ${msg}`))
    }
}

const getBearerToken = async () => {
    console.error(chalk.blue("[i] Getting bearer token..."));
    const tmpTokenResponse = await axios('https://api.twitter.com/oauth2/token', {
        headers: {
            Authorization: TW_ANDROID_BASIC_TOKEN,
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        method: 'post',
        data: 'grant_type=client_credentials'
    });
    return Object.values(tmpTokenResponse.data).join(" ");
}
// The bearer token is immutable
// Bearer AAAAAAAAAAAAAAAAAAAAAFXzAwAAAAAAMHCxpeSDG1gLNLghVe8d74hl6k4%3DRUMF4xAQLsbeBhTSRrCiQpJtxoGWeyHrDb5te2jpGskWDFW82F
const bearer_token = await getBearerToken()
console.error(chalk.blue(`[i] bearer token = ${bearer_token}`));
if (bearer_token.toLowerCase() !== "Bearer AAAAAAAAAAAAAAAAAAAAAFXzAwAAAAAAMHCxpeSDG1gLNLghVe8d74hl6k4%3DRUMF4xAQLsbeBhTSRrCiQpJtxoGWeyHrDb5te2jpGskWDFW82F".toLowerCase()) {
    console.warn(chalk.yellow("[!] bearer token does not match expected value"))
} else {
    console.error(chalk.green('[i] bearer token matches expected value'))
}

console.error(chalk.blue(`[i] getting guest token`))
const guest_token = (await axios("https://api.twitter.com/1.1/guest/activate.json", {
    headers: {
        Authorization: bearer_token
    },
    method: "post"
})).data.guest_token
console.error(chalk.blue(`[i] guest token = ${guest_token}`));

console.error(chalk.blue(`[i] getting flow_token`))
const flow_token_r = (await axios('https://api.twitter.com/1.1/onboarding/task.json?flow_name=welcome&api_version=1&known_device_token=&sim_country_code=us', {
    headers: {
        Authorization: bearer_token,
        'Content-Type': 'application/json',
        'User-Agent': 'TwitterAndroid/9.95.0-release.0 (29950000-r-0) ONEPLUS+A3010/9 (OnePlus;ONEPLUS+A3010;OnePlus;OnePlus3;0;;1;2016)',
        'X-Twitter-API-Version': 5,
        'X-Twitter-Client': 'TwitterAndroid',
        'X-Twitter-Client-Version': '9.95.0-release.0',
        'OS-Version': '28',
        'System-User-Agent': 'Dalvik/2.1.0 (Linux; U; Android 9; ONEPLUS A3010 Build/PKQ1.181203.001)',
        'X-Twitter-Active-User': 'yes',
        'X-Guest-Token': guest_token
    },
    method: 'post',
    data: '{"flow_token":null,"input_flow_data":{"country_code":null,"flow_context":{"start_location":{"location":"splash_screen"}},"requested_variant":null,"target_user_id":0},"subtask_versions":{"generic_urt":3,"standard":1,"open_home_timeline":1,"app_locale_update":1,"enter_date":1,"email_verification":3,"enter_password":5,"enter_text":5,"one_tap":2,"cta":7,"single_sign_on":1,"fetch_persisted_data":1,"enter_username":3,"web_modal":2,"fetch_temporary_password":1,"menu_dialog":1,"sign_up_review":5,"interest_picker":4,"user_recommendations_urt":3,"in_app_notification":1,"sign_up":2,"typeahead_search":1,"user_recommendations_list":4,"cta_inline":1,"contacts_live_sync_permission_prompt":3,"choice_selection":5,"js_instrumentation":1,"alert_dialog_suppress_client_events":1,"privacy_options":1,"topics_selector":1,"wait_spinner":3,"tweet_selection_urt":1,"end_flow":1,"settings_list":7,"open_external_link":1,"phone_verification":5,"security_key":3,"select_banner":2,"upload_media":1,"web":2,"alert_dialog":1,"open_account":2,"action_list":2,"enter_phone":2,"open_link":1,"show_code":1,"update_users":1,"check_logged_in_account":1,"enter_email":2,"select_avatar":4,"location_permission_prompt":2,"notifications_permission_prompt":4}}'
})).data
const flow_token = flow_token_r.flow_token
debug(`flow_token => ${JSON.stringify(flow_token_r, null, 2)}`)
console.error(chalk.blue(`[i] flow_token = ${flow_token}`))

const tasks_raw = (await axios('https://api.twitter.com/1.1/onboarding/task.json', {
    headers: {
        Authorization: bearer_token,
        'Content-Type': 'application/json',
        'User-Agent': 'TwitterAndroid/9.95.0-release.0 (29950000-r-0) ONEPLUS+A3010/9 (OnePlus;ONEPLUS+A3010;OnePlus;OnePlus3;0;;1;2016)',
        'X-Twitter-API-Version': 5,
        'X-Twitter-Client': 'TwitterAndroid',
        'X-Twitter-Client-Version': '9.95.0-release.0',
        'OS-Version': '28',
        'System-User-Agent': 'Dalvik/2.1.0 (Linux; U; Android 9; ONEPLUS A3010 Build/PKQ1.181203.001)',
        'X-Twitter-Active-User': 'yes',
        'X-Guest-Token': guest_token
    },
    method: 'post',
    data: '{"flow_token":"' + flow_token + '","subtask_inputs":[{"open_link":{"link":"next_link"},"subtask_id":"NextTaskOpenLink"}],"subtask_versions":{"generic_urt":3,"standard":1,"open_home_timeline":1,"app_locale_update":1,"enter_date":1,"email_verification":3,"enter_password":5,"enter_text":5,"one_tap":2,"cta":7,"single_sign_on":1,"fetch_persisted_data":1,"enter_username":3,"web_modal":2,"fetch_temporary_password":1,"menu_dialog":1,"sign_up_review":5,"interest_picker":4,"user_recommendations_urt":3,"in_app_notification":1,"sign_up":2,"typeahead_search":1,"user_recommendations_list":4,"cta_inline":1,"contacts_live_sync_permission_prompt":3,"choice_selection":5,"js_instrumentation":1,"alert_dialog_suppress_client_events":1,"privacy_options":1,"topics_selector":1,"wait_spinner":3,"tweet_selection_urt":1,"end_flow":1,"settings_list":7,"open_external_link":1,"phone_verification":5,"security_key":3,"select_banner":2,"upload_media":1,"web":2,"alert_dialog":1,"open_account":2,"action_list":2,"enter_phone":2,"open_link":1,"show_code":1,"update_users":1,"check_logged_in_account":1,"enter_email":2,"select_avatar":4,"location_permission_prompt":2,"notifications_permission_prompt":4}}'
})).data

debug(`tasks => ${JSON.stringify(tasks_raw, null, 2)}`);
const subtasks = tasks_raw.subtasks;
const account = subtasks.find(task => task.subtask_id === 'OpenAccount')?.open_account

async function tryAppendJSON(file, content) {

  async function tryRead(file, _default = "[]") {
    try {
      const rawD = await Deno.readTextFile(file);
      return rawD
    } catch (e) {
      if (e?.code === "ENOENT") {
        return _default
      } else {
        throw e
      }
    }
  }

  if (file) {
    debug(`attempting to write to file ${file}`)
    try {
      const rD = await tryRead(file)
      debug("read old file with contents => " + rD);
      const oldData = JSON.parse(rD)
      if (!Array.isArray(oldData)) {
        console.error(chalk.red(`[!] top-level object of existing file ${file} is not an array, not proceeding.`))
        return false;
      }
      oldData.push(content)
      await Deno.writeTextFile(file, JSON.stringify(oldData, null, 4))
      return true
    } catch (e) {
      console.error(chalk.red("[!] Uncaught error", e))
      return false
    }
  } else {
    debug("file is not truthy, bailing")
    return false
  }
}

if (!account) {
    console.error(chalk.red(`[!] unable to acquire account token. API response => ${JSON.stringify(account)}`))
    console.error(chalk.red(`[!] this might be because of a plethora of reasons, but most likely it's due to your IP being rate-limited.`))
    console.error(chalk.red(`[!] try again with a new IP address or retry in a day.`))
    console.info(chalk.yellow(`[i] not writing to file because we did not receive a valid account object.`))
} else {
    const outfile = Deno.args.find(i => i.match(/^(?!-).*$/));
    if (!await tryAppendJSON(outfile, account)) {
      debug("appending to file failed, printing to stdout instead.")
      if (NO_PRETTYPRINT) {
        console.log(JSON.stringify(account))
      } else {
        console.log(account)
      }
    }
}
