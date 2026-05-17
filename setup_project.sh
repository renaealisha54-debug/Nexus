#!/bin/bash

# Define the root project name
PROJECT_NAME="NexusIDE"

echo "🚀 Initializing directory structure for Android project: $PROJECT_NAME..."

# Create core Android directory tree layout
mkdir -p "$PROJECT_NAME/app/src/main/assets"
mkdir -p "$PROJECT_NAME/app/src/main/java/com/nexus/ide"
mkdir -p "$PROJECT_NAME/app/src/main/res/values"

echo "📂 Directories created. Generating source files..."

# 1. Generate settings.gradle
cat << 'EOF' > "$PROJECT_NAME/settings.gradle"
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "Nexus IDE"
include ':app'
EOF

# 2. Generate root build.gradle
cat << 'EOF' > "$PROJECT_NAME/build.gradle"
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.2.2'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

task clean(type: Delete) {
    delete rootProject.buildDir;
}
EOF

# 3. Generate app module build.gradle
cat << 'EOF' > "$PROJECT_NAME/app/build.gradle"
plugins {
    id 'com.android.application'
}

android {
    namespace 'com.nexus.ide'
    compileSdk 34

    defaultConfig {
        applicationId "com.nexus.ide"
        minSdk 24
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }

    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.11.0'
}
EOF

# 4. Generate Android Manifest file
cat << 'EOF' > "$PROJECT_NAME/app/src/main/AndroidManifest.xml"
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.nexus.ide">

    <uses-permission android:name="android.permission.INTERNET" />

    <application
        android:allowBackup="true"
        android:label="Nexus IDE"
        android:supportsRtl="true"
        android:theme="@style/Theme.AppCompat.NoActionBar"
        android:hardwareAccelerated="true">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:windowSoftInputMode="adjustResize"
            android:screenOrientation="portrait">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
EOF

# 5. Generate WebView Native Java Container Activity
cat << 'EOF' > "$PROJECT_NAME/app/src/main/java/com/nexus/ide/MainActivity.java"
package com.nexus.ide;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.webkit.JavascriptInterface;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private WebView mWebView;

    @Override
    @SuppressLint("SetJavaScriptEnabled")
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        mWebView = new WebView(this);
        setContentView(mWebView);

        WebSettings webSettings = mWebView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);
        webSettings.setDatabaseEnabled(true);
        webSettings.setAllowFileAccess(true);

        webSettings.setSupportZoom(false);
        webSettings.setBuiltInZoomControls(false);

        mWebView.setWebViewClient(new WebViewClient());
        mWebView.addJavascriptInterface(new WebAppInterface(), "AndroidBridge");

        mWebView.loadUrl("file:///android_asset/index.html");
    }

    @Override
    public void onBackPressed() {
        if (mWebView.canGoBack()) {
            mWebView.goBack();
        } else {
            super.onBackPressed();
        }
    }

    public class WebAppInterface {
        @JavascriptInterface
        public void showToast(String toast) {
            Toast.makeText(MainActivity.this, toast, Toast.LENGTH_SHORT).show();
        }
    }
}
EOF

# 6. Generate Mobile-Optimized Local HTML Core Editor
cat << 'EOF' > "$PROJECT_NAME/app/src/main/assets/index.html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, interactive-widget=resizes-content">
    <title>Nexus IDE</title>
    <style>
        :root {
            --bg: #0b0f19;
            --surface: #151926;
            --accent: #4f46e5;
            --text: #f1f5f9;
            --muted: #64748b;
        }

        body {
            margin: 0;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: var(--bg);
            color: var(--text);
            height: 100vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        header {
            padding: 1rem;
            background: var(--surface);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #1e293b;
        }

        .brand { font-weight: 700; font-size: 1.25rem; color: var(--accent); }

        .btn {
            background: #1e293b;
            color: var(--text);
            border: 1px solid #334155;
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            cursor: pointer;
        }

        main { flex: 1; display: flex; flex-direction: column; position: relative; }
        
        #editor {
            flex: 1;
            background: #050505;
            border: none;
            color: #cbd5e1;
            padding: 1rem;
            font-family: monospace;
            resize: none;
            outline: none;
            font-size: 16px;
        }

        #ai-panel {
            position: absolute;
            bottom: 1rem;
            left: 5%;
            width: 90%;
            background: var(--surface);
            padding: 1rem;
            border-radius: 0.75rem;
            border: 1px solid var(--accent);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.5);
            box-sizing: border-box;
            display: none;
        }

        #ai-panel.active { display: block; }

        .ai-form { display: flex; gap: 0.5rem; }
        #ai-input {
            flex: 1;
            background: #050505;
            border: 1px solid #334155;
            color: var(--text);
            padding: 0.5rem;
            border-radius: 0.25rem;
            outline: none;
        }

        nav {
            padding: 0.75rem;
            background: var(--surface);
            display: flex;
            justify-content: space-around;
            border-top: 1px solid #1e293b;
        }

        .nav-btn { cursor: pointer; color: var(--muted); display: flex; flex-direction: column; align-items: center; }
        .nav-btn.active { color: var(--accent); }
    </style>
</head>
<body>

    <header>
        <div class="brand">Nexus IDE</div>
        <div>
            <button id="btn-ai" class="btn">✨ AI</button>
            <button id="btn-run" class="btn">▶️</button>
        </div>
    </header>

    <main>
        <textarea id="editor" placeholder="Start coding your future..."></textarea>
        
        <div id="ai-panel">
            <div class="ai-form">
                <input type="text" id="ai-input" placeholder="Ask AI to optimize, refactor, or debug...">
                <button id="btn-ai-exec" class="btn">Execute</button>
            </div>
        </div>
    </main>

    <nav>
        <div class="nav-btn active">💻 Files</div>
        <div class="nav-btn">📝 Notes</div>
        <div class="nav-btn">⚙️ Settings</div>
    </nav>

    <script>
        const editor = document.getElementById('editor');
        const aiPanel = document.getElementById('ai-panel');
        const aiInput = document.getElementById('ai-input');

        document.getElementById('btn-ai').addEventListener('click', () => {
            aiPanel.classList.toggle('active');
            if(aiPanel.classList.contains('active')) aiInput.focus();
        });

        document.getElementById('btn-run').addEventListener('click', () => {
            if (window.AndroidBridge) {
                window.AndroidBridge.showToast("Compiling code in sandbox...");
            } else {
                alert("Compiling...");
            }
        });

        document.getElementById('btn-ai-exec').addEventListener('click', () => {
            const input = aiInput.value;
            if(!input) return;
            editor.value += `\n// AI Suggestion for: ${input}\n// Refactored logic implemented.`;
            aiInput.value = '';
            aiPanel.classList.remove('active');
        });
    </script>
</body>
</html>
EOF

echo "✅ Generation complete! Open '$PROJECT_NAME' directly in Android Studio or compile with Gradle via './gradlew assembleDebug'."
