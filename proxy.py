import os
import ctypes
import winreg as reg

def set_proxy_settings(proxy_enable, proxy_server=""):
    # Registry key for Internet Settings
    registry_key = r"Software\Microsoft\Windows\CurrentVersion\Internet Settings"

    try:
        # Open the registry key for Internet Settings
        key = reg.OpenKey(reg.HKEY_CURRENT_USER, registry_key, 0, reg.KEY_SET_VALUE)

        # Enable or disable manual proxy settings
        reg.SetValueEx(key, "ProxyEnable", 0, reg.REG_DWORD, int(proxy_enable))

        if proxy_enable:
            # Set proxy server to localhost and port 8090
            reg.SetValueEx(key, "ProxyServer", 0, reg.REG_SZ, proxy_server)

        # Notify changes to the system
        ctypes.windll.wininet.InternetSetOptionW(0, 39, 0, 0)

        print("Proxy settings updated successfully.")

    except Exception as e:
        print(f"Error: {e}")
    finally:
        try:
            # Close the registry key
            reg.CloseKey(key)
        except:
            pass

def main_menu():
    print("1. Neoload Record mode")
    print("2. Web mode")
    print("3. Exit")

    choice = input("Enter your choice (1/2/3): ")

    if choice == "1":
        set_proxy_settings(proxy_enable=True, proxy_server="http=127.0.0.1:8090;https=127.0.0.1:8090")
    elif choice == "2":
        set_proxy_settings(proxy_enable=False)
    elif choice == "3":
        exit()
    else:
        print("Invalid choice. Please enter 1, 2, or 3.")
        main_menu()

if __name__ == "__main__":
    main_menu()
