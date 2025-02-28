# Supabase Word App

Flutter test app using supabase, google oauth

## Install Flutter (If Not Installed)

If you haven't installed Flutter yet, download and install it from:
👉 [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)

Then, check if Flutter is installed correctly by running:
```bash
flutter doctor
```

## Download project from github
clone from github
```bash
git remote add origin https://github.com/Grois333/flutter-todo-supabase.git
```
and move flutter-todo-supabase directory
```bash
cd flutter-todo-supabase
```

install flutter packages by following command:
```bash
flutter pub get
```

## Run Flutter Project
### 🔹 Set env
Copy .env.example to .env

- Windows (Command Prompt or Powershell)
```bash
copy .env.example .env
```

- Mac & Linux (Terminal)
```bash
chmod +x setup_config.sh
```

```
./setup_config.sh
```

In the .env file need to set real thing
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
GOOGLE_CLIENT_ID=google_web_clint_id
IOS_CLIENT_ID=google_ios_client_id
GOOGLE_API_CLIENT_ID_URL_SCHEME=google_ios_client_id_url_scheme
```
You should make these from **Supabase Dashbord** and **Google Developer Console**.
You can refer in "[**Set Up Supabase Api key**](#set-up-supabase-api-key)" and "[**Set Up Google OAuth in the Supabase Dashboard**](#set-up-google-oauth-in-the-supabase-dashboard)"

### 🔹 Make word table in supabase dashboard by manually
From `supabase/functions/create_words_table.sql`
- move to **Supabase Dashboard**
- On the left sidebar, go to **Database** > **SQL Editor**.
- Click "**New Query**" and enter your SQL commands.
- Click **RUN**.

you will see words table in tables list.

### 🔹 Run Command
```
flutter run
```
or you can select **device**
```
#android
flutter run -d <emulator-id>

#ios
flutter run -d <simulator-id>
```

### Using auto_route in app
Create `app_router.dart` and add AutoRoutes
e.g.
```
@RoutePage()
class WordListScreen extends ConsumerWidget {...}
```

The following command created `app_router.gr.dart` and managed navigation using **auto_route**.
```
flutter pub run build_runner build
```

<!-- Supabase API -->
## Set Up Supabase Api key
### Create a Supabase Project
1. Go to [Supabase Dashboard](https://supabase.com/dashboard/)
2. **Sign** in or **Create an account** if you don’t have one.
3. Click "**New Project**".
4. Enter:
    - **Project name** (e.g., flutter-word-project)
    - **Database password** (Remember this for later)
    - **Select Region**
5. Click "**Create new project**" and wait for Supabase to set it up (this may take a minute).


### Get Supabase Url & Anon Key
1. After the project is created, go to the "**Settings**" tab in the left sidebar.
2. Select "**Data API**".
3. Under the **Project Url** section, you will find:
    - **Project URL** → This is your ```SUPABASE_URL```
4. Under the **Project API Keys** section, you will find:
    - **Anon Public Key** → This is your ```SUPABASE_ANON_KEY```

<!-- Setup Google OAuth in Supabase -->
## Set Up Google OAuth in the Supabase Dashboard
1. Go to [Supabase Dashboard](https://supabase.com/dashboard/)
2. Select **your project** and go to the "**Authentication**" section from the left sidebar.
3. Click on "**Sign In / Up**" and then go to "OAuth Providers".
4. Under **Google**, click **Enable**.
5. You will need to provide your **Google OAuth credentials**: ([Reference guide](https://www.balbooa.com/help/gridbox-documentation/integrations/other/google-client-id))
    - Go to the [Google Developer Console](https://console.cloud.google.com/)
    - Create a **new project** (or use an existing one).
    - Enable the Google APIs:
        - After creating the project, you will be redirected to the **Google Cloud Console** dashboard for your new project.
        - On the **API & Services** page, click on "**Enable APIs and Services**".
        - In the search bar, type "**Google Identity**" and select "**Google Identity Services**".
        - Click on "**Enable**" to enable the Google Identity API.
        
    - Create "**OAuth 2.0 Credentials**":
        - From the **API & Services** page, click "**Credentials**" in the left sidebar.
        - Click on "**Create Credentials**" and choose "**OAuth Client ID**".
        - You will be asked to **configure the consent screen**. Click "**Configure consent screen**".

    - Configure the **OAuth consent Screen**:
        - **OAuth Consent Screen Setup**:
            - Select "**External**" for user type (for public apps, use "External").
            - Fill out the required fields:
                - **App name**: Enter the name of your app (e.g., Supabase Word App).
                - **User support email**: Use your email.
                - **Developer contact email**: Use your email (this can be the same).
            - Click "**Save and Continue**" (You can leave the other fields empty for now).
        - **Scopes**:
            - In the **Scopes** section, click "**Save and Continue**" (no need to configure any extra scopes for basic authentication).
        - **Test Users**:
            - In the **Test Users** section, you can add email addresses of people you want to test the authentication with. For now, you can skip this or add your own email.
    
    - Set Up **OAuth Credentials**
        - **Create OAuth Client ID**:
            - For **Android**:
                - Now, select **Web application** as the **application type**.
                - In the **Name** field, enter something like ```Flutter OAuth Web Client```.
                - **Authorized JavaScript Origins**: You can leave this empty (this is more useful for web apps).
                - **Authorized redirect URIs**: Add the following URL, which will redirect the user after Google authentication:
                    - For **Supabase** you need to take OAuth Callback url from above **OAuth Provide / Google Enable**
                        ```
                        https://your-project.supabase.co/auth/v1/callback
                        ```
                - Click **CREATE**
            - For **IOS**:
                - Now, select **iOS** as the **application type**.
                - In the **Name** field, enter something like ```Flutter OAuth IOS Client```.
                - In **Bundle Id field**, enter bundle identifier from ```info.plist``` (e.g., com.example.supabaseWordApp)
                - For **App Store ID** and **Team ID**, leave to empty
                - Click **CREATE**
        - **Copy credentials**:
            Once the client ID is created, you will see a **Client ID** and **Client Secret**.
            **Copy** both the `Client ID` and `Client Secret`. You will use these in the Supabase settings later.
            For IOS **Copy** the `iOS URL scheme` into info.plist file.

6. **Configure Google OAuth in Supabase**
    - In **OAuth Provider / Google** 
        - Paste the **Client ID** and **Client Secret** that you copied from the Google Developer Console into the corresponding fields in Supabase.
        - Click **Save**