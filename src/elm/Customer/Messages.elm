module Customer.Messages exposing (Msg(..))

import Http
import Shared.SearchBar as SearchBar
import Customer.Customer exposing (Customer, CustomerValidation, CustomerPic)
import Customer.Models exposing (CustomerTab, View)
import Shared.ViewReceipt as ViewReceipt
import Shared.PicLoader as PicLoader
import Shared.PicListLoader as PicListLoader
import Shared.ImgInput as ImgInput


type Msg
    = NoOp
    | SearchBarMsg SearchBar.Msg
    | ViewReceiptMsg ViewReceipt.Msg
    | PicLoaderMsg PicLoader.Msg
    | PicListLoaderMsg PicListLoader.Msg
    | ImgInputMsg ImgInput.Msg
    | OnSearch (Result Http.Error (List Customer))
    | SelectCrumb View
    | CustomerPicReq (Result Http.Error CustomerPic)
    | OnNewCustomer
    | OnNewCustomerReset
    | OnNewCustomerSave
    | NewCustomerReq (Result Http.Error Customer)
    | EditCustomer
    | OnEditCustomerSave
    | OnEditCustomerCancel
    | EditCustomerReq (Result Http.Error Customer)
    | OnEditOrNewCustomerInput (Customer -> String -> Customer) String
    | OnCustomerValidation CustomerValidation



--    | OnNewCustomerSave
