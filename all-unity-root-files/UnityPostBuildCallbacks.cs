// Assets/Editor/UnityPostBuildCallbacks.cs

// This file will ensure there is a 'version.txt' placed in the Build directory directly after each build
// To edit this version, go to Unity > Edit > Project Settings > Player > Version
// The file contents will be like below (Company Name, Product Name, Version)

// Example: /Build/version.txt

// DefaultCompany
// my-project
// 0.1.0


# if UNITY_EDITOR

using System.IO;
using System.Text;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;

class UnityPostBuildCallbacks : IPostprocessBuildWithReport
{
    public int callbackOrder { get { return 100; } }
    public void OnPostprocessBuild(BuildReport report)
    {
        // Write 'version.txt' in the build root directory after the build is completed
        var buildOutputFile = new FileInfo(report.summary.outputPath);
        var versionFile = new FileInfo(Path.Combine(buildOutputFile.Directory.FullName, "version.txt"));

        var contents = new StringBuilder();
        contents.AppendLine(PlayerSettings.companyName);
        contents.AppendLine(PlayerSettings.productName);
        contents.Append(PlayerSettings.bundleVersion);

        File.WriteAllText(versionFile.FullName, contents.ToString());
    }
}
#endif
