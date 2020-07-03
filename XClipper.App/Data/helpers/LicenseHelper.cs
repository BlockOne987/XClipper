﻿using RestSharp;
using System;
using System.Threading.Tasks;
using static Components.Core;
using static Components.DefaultSettings;
using static Components.Constants;
using System.Net;
using Newtonsoft.Json.Linq;
using System.Windows.Threading;
using System.Windows;

#nullable enable

namespace Components
{
    public class LicenseHelper : ILicense
    {
        public void Initiate(Action<Exception?> block)
        {
            checkForLicense().ContinueWith(t =>
            {
                if (t?.Result != null)
                {
                    var obj = JObject.Parse(t.Result);
                    var uid = obj["data"]["applicationId"].ToString();
                    var type = obj["data"]["licenseType"].ToString().ToEnum<LicenseType>();
                    if (uid == UniqueID)
                    {
                        IsPurchaseDone = type != LicenseType.Invalid;
                        LicenseStrategy = type;
                        block(null);
                    }
                    else block(new Exception("The given application Id doesn't match the current UID"));
                }
            });
        }
        private async Task<string?> checkForLicense()
        {
            var client = new RestClient($"{AUTHOR_SERVER}/xclipper/validate?uid={UniqueID}");
            client.Timeout = RESTSHARP_TIMEOUT;
            try
            {
                var response = await client.ExecuteTaskAsync(new RestRequest(Method.GET));
                if (response.StatusCode == HttpStatusCode.OK)
                    return response.Content;
            }
            catch { }
            return null;
        }
    }
}
