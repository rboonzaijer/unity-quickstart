# if UNITY_EDITOR

// Assets/Editor/UnityPostBuildCallbacks.cs

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
