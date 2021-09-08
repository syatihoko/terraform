D:\Programs\Terraform\bin\terraform apply


#Загрузка сертификата.
https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/client-authentication.html#mutual


To generate the server and client certificates and keys and upload them to ACM

Open the OpenVPN Community Downloads page, download the Windows installer for your version of Windows, and run the installer.

Open the EasyRSA releases page and download the ZIP file for your version of Windows. Extract the ZIP file and copy the EasyRSA folder to the \Program Files\OpenVPN folder.

Open the command prompt as an Administrator, navigate to the \Program Files\OpenVPN\EasyRSA directory, and run the following command to open the EasyRSA 3 shell.

C:\Program Files\OpenVPN\EasyRSA> EasyRSA-Start
Initialize a new PKI environment.

# ./easyrsa init-pki
To build a new certificate authority (CA), run this command and follow the prompts.

# ./easyrsa build-ca nopass
Generate the server certificate and key.

# ./easyrsa build-server-full server nopass
Generate the client certificate and key.

# ./easyrsa build-client-full client1.domain.tld nopass
You can optionally repeat this step for each client (end user) that requires a client certificate and key.

Exit the EasyRSA 3 shell.

# exit
Copy the server certificate and key and the client certificate and key to a custom folder and then navigate into the custom folder.

Before you copy the certificates and keys, create the custom folder by using the mkdir command. The following example creates a custom folder in your C:\ drive.

C:\Program Files\OpenVPN\EasyRSA> mkdir C:\custom_folder
C:\Program Files\OpenVPN\EasyRSA> copy pki\ca.crt C:\custom_folder
C:\Program Files\OpenVPN\EasyRSA> copy pki\issued\server.crt C:\custom_folder
C:\Program Files\OpenVPN\EasyRSA> copy pki\private\server.key C:\custom_folder
C:\Program Files\OpenVPN\EasyRSA> copy pki\issued\client1.domain.tld.crt C:\custom_folder
C:\Program Files\OpenVPN\EasyRSA> copy pki\private\client1.domain.tld.key C:\custom_folder
C:\Program Files\OpenVPN\EasyRSA> cd C:\custom_folder
Upload the server certificate and key and the client certificate and key to ACM. Be sure to upload them in the same Region in which you intend to create the Client VPN endpoint. The following commands use the AWS CLI to upload the certificates. To upload the certificates using the ACM console instead, see Import a certificate in the AWS Certificate Manager User Guide.


#Импорт сертификата. C:\Users\kaa\OpenVPN\config\new\
#aws acm import-certificate --certificate fileb://server.crt --private-key fileb://server.key --certificate-chain fileb://ca.crt
aws acm import-certificate --certificate server.crt --private-key server.key --certificate-chain ca.crt
aws acm import-certificate --certificate fileb://client1.domain.tld.crt --private-key fileb://client1.domain.tld.key --certificate-chain fileb://ca.crt
You do not need to upload the client certificate to ACM unless the CA of the client certificate is different from the CA of the server certificate. In the steps above, the client certificate uses the same CA as the server certificate, however, the steps to upload the client certificate are included here for completeness.


#Step 2: Create a Client VPN endpoint
https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-getting-started.html

#Подключаемся к машине
ssh -i "151_new2.pem" ec2-user@172.31.112.100