using System;
using System.Collections.Generic;
using Library.DAL.MasterSetup_DAL;
using Library.DAO.MasterSetup_DAO;

namespace Library.BLL.MasterSetup_BLL
{
    public class CustomerInvoiceLimitService
    {
        private CustomerInvoiceLimitRepository repository = new CustomerInvoiceLimitRepository();

        public string Save(CustomerInvoiceLimitModel model)
        {
            if (model.CustomerId <= 0)
            {
                return "Customer is required.";
            }
            if (model.MaximumInvoiceValue < 1)
            {
                return "Maximum Invoice Value must be greater than 0.";
            }

            var existingList = repository.GetList();
            if (existingList != null && existingList.Exists(x => x.CustomerId == model.CustomerId))
            {
                return "This customer already exists in Order Limit Setup.";
            }

            return repository.Insert(model);
        }

        public string Update(CustomerInvoiceLimitModel model)
        {
            if (model.Id <= 0)
            {
                return "Invalid record.";
            }
            if (model.MaximumInvoiceValue < 1)
            {
                return "Maximum Invoice Value must be greater than 0.";
            }

            return repository.Update(model);
        }

        public string Delete(int id)
        {
            if (id <= 0)
            {
                return "Invalid record.";
            }
            return repository.Delete(id);
        }

        public CustomerInvoiceLimitViewModel GetById(int id)
        {
            return repository.GetById(id);
        }

        public List<CustomerInvoiceLimitViewModel> GetList()
        {
            return repository.GetList();
        }

        public List<CustomerAutoCompleteViewModel> GetCustomerAutoComplete(string keyword)
        {
            if (string.IsNullOrWhiteSpace(keyword))
            {
                return new List<CustomerAutoCompleteViewModel>();
            }
            return repository.GetCustomerAutoComplete(keyword);
        }

        /// <summary>
        /// Validates if a new invoice amount exceeds the customer's maximum allowed invoice value.
        /// This setup will be used during Invoice Generation.
        /// </summary>
        public bool ValidateInvoiceLimit(int customerId, decimal invoiceAmount, out string errorMessage)
        {
            errorMessage = string.Empty;
            decimal limit = 50000; // Default limit
            
            // Get all configurations, find the active one for this customer
            var list = repository.GetList();
            var customerConfig = list.Find(x => x.CustomerId == customerId && x.IsActive);
            
            if (customerConfig != null)
            {
                limit = customerConfig.MaximumInvoiceValue;
            }

            if (invoiceAmount > limit)
            {
                errorMessage = "Invoice amount exceeds the customer's maximum allowed invoice value.";
                return false;
            }

            return true;
        }

        public string SaveInvoiceNotBinding(InvoiceNotBindingModel model)
        {
            if (string.IsNullOrWhiteSpace(model.ApplyType))
            {
                model.ApplyType = "Customer";
            }

            bool isCustomerType = model.ApplyType == "CustomerType";

            if (isCustomerType)
            {
                if (model.CustomerTypeId <= 0)
                {
                    return "Customer Type is required.";
                }
            }
            else if (model.CustomerId <= 0)
            {
                return "Customer is required.";
            }

            if (model.ActiveFromDate == DateTime.MinValue)
            {
                return "Active From Date is required.";
            }

            var existingInvList = repository.GetInvoiceNotBindingList();
            if (existingInvList != null)
            {
                bool duplicate = isCustomerType
                    ? existingInvList.Exists(x => x.ApplyType == "CustomerType" && x.CustomerTypeId == model.CustomerTypeId)
                    : existingInvList.Exists(x => x.ApplyType != "CustomerType" && x.CustomerId == model.CustomerId);

                if (duplicate)
                {
                    return isCustomerType
                        ? "This customer type already exists in Invoice Limit Setup."
                        : "This customer already exists in Invoice Limit Setup.";
                }
            }

            return repository.InsertInvoiceNotBinding(model);
        }

        public List<CustomerTypeViewModel> GetCustomerTypeListActive()
        {
            return repository.GetCustomerTypeListActive();
        }

        public string UpdateInvoiceNotBinding(InvoiceNotBindingModel model)
        {
            if (model.InvoiceNotBindingId <= 0)
            {
                return "Invalid record.";
            }
            if (model.ActiveFromDate == DateTime.MinValue)
            {
                return "Active From Date is required.";
            }

            return repository.UpdateInvoiceNotBinding(model);
        }

        public string DeleteInvoiceNotBinding(int id)
        {
            if (id <= 0)
            {
                return "Invalid record.";
            }
            return repository.DeleteInvoiceNotBinding(id);
        }

        public InvoiceNotBindingViewModel GetInvoiceNotBindingById(int id)
        {
            return repository.GetInvoiceNotBindingById(id);
        }

        public List<InvoiceNotBindingViewModel> GetInvoiceNotBindingList()
        {
            return repository.GetInvoiceNotBindingList();
        }
    }
}
