import Foundation
import XCTest
@testable import MiseEnPlace

class MultimediaTests: XCTestCase {
    
    func testImageURL() async throws {
        var ingredient = TestIngredient()
        ingredient.uuid = UUID(uuidString: "a0ee42e5-c0d1-4720-a919-57acbd8dafc0")!
        
        XCTAssertNil(ingredient.imagePath)
        
        let base64 = imageData.joined()
        guard let data = Data(base64Encoded: base64) else {
            XCTFail("Failed to decode base64 image data.")
            return
        }
        
        let path = try MediaManager.shared.imagePath(for: ingredient, writingData: data, name: ingredient.uuid.uuidString)
        ingredient.imagePath = path
        
        let url = try XCTUnwrap(MediaManager.shared.imageURL(for: ingredient))
        
        _ = try Data(contentsOf: url)
        
        try MediaManager.shared.removeImage(for: ingredient)
        
        do {
            _ = try Data(contentsOf: url)
            XCTFail("File shouldn't exist")
        } catch {
        }
    }
}

fileprivate let imageData: [String] = [
    "/9j/4AAQSkZJRgABAQAASABIAAD/4QBMRXhpZgAATU0AKgAAAAgAAgESAAMAAAABAAEAAIdpAAQAAAABAAAAJgAAAAAAAqACAAQAAAABAAAAXKADAAQAAAABAAAAZAAAAAD/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+/+IMWElDQ19QUk9GSUxFAAEBAAAMSExpbm8CEAAAbW50clJHQiBYWVogB84AAgAJAAYAMQAAYWNzcE1TRlQAAAAASUVDIHNSR0IAAAAAAAAAAAAAAAAAAPbWAAEAAAAA0y1IUCAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARY3BydAAAAVAAAAAzZGVzYwAAAYQAAABsd3RwdAAAAfAAAAAUYmtwdAAAAgQAAAAUclhZWgAAAhgAAAAUZ1hZWgAAAiwA",
    "AAAUYlhZWgAAAkAAAAAUZG1uZAAAAlQAAABwZG1kZAAAAsQAAACIdnVlZAAAA0wAAACGdmlldwAAA9QAAAAkbHVtaQAAA/gAAAAUbWVhcwAABAwAAAAkdGVjaAAABDAAAAAMclRSQwAABDwAAAgMZ1RSQwAABDwAAAgMYlRSQwAABDwAAAgMdGV4dAAAAABDb3B5cmlnaHQgKGMpIDE5OTggSGV3bGV0dC1QYWNrYXJkIENvbXBhbnkAAGRlc2MAAAAAAAAAEnNSR0IgSUVDNjE5NjYtMi4xAAAAAAAAAAAAAAASc1JHQiBJRUM2MTk2Ni0yLjEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFhZWiAAAAAAAADzUQABAAAAARbMWFlaIAAAAAAAAAAAAAAAAAAAAABYWVogAAAAAAAAb6IAADj1AAADkFhZWiAAAAAAAABimQAAt4UAABja",
    "WFlaIAAAAAAAACSgAAAPhAAAts9kZXNjAAAAAAAAABZJRUMgaHR0cDovL3d3dy5pZWMuY2gAAAAAAAAAAAAAABZJRUMgaHR0cDovL3d3dy5pZWMuY2gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAZGVzYwAAAAAAAAAuSUVDIDYxOTY2LTIuMSBEZWZhdWx0IFJHQiBjb2xvdXIgc3BhY2UgLSBzUkdCAAAAAAAAAAAAAAAuSUVDIDYxOTY2LTIuMSBEZWZhdWx0IFJHQiBjb2xvdXIgc3BhY2UgLSBzUkdCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGRlc2MAAAAAAAAALFJlZmVyZW5jZSBWaWV3aW5nIENvbmRpdGlvbiBpbiBJRUM2MTk2Ni0yLjEAAAAAAAAAAAAAACxSZWZlcmVuY2UgVmlld2luZyBDb25kaXRpb24gaW4gSUVDNjE5NjYt",
    "Mi4xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB2aWV3AAAAAAATpP4AFF8uABDPFAAD7cwABBMLAANcngAAAAFYWVogAAAAAABMCVYAUAAAAFcf521lYXMAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAKPAAAAAnNpZyAAAAAAQ1JUIGN1cnYAAAAAAAAEAAAAAAUACgAPABQAGQAeACMAKAAtADIANwA7AEAARQBKAE8AVABZAF4AYwBoAG0AcgB3AHwAgQCGAIsAkACVAJoAnwCkAKkArgCyALcAvADBAMYAywDQANUA2wDgAOUA6wDwAPYA+wEBAQcBDQETARkBHwElASsBMgE4AT4BRQFMAVIBWQFgAWcBbgF1AXwBgwGLAZIBmgGhAakBsQG5AcEByQHRAdkB4QHpAfIB+gIDAgwCFAIdAiYCLwI4AkECSwJUAl0CZwJxAnoChAKOApgCogKsArYCwQLLAtUC4ALrAvUDAAML",
    "AxYDIQMtAzgDQwNPA1oDZgNyA34DigOWA6IDrgO6A8cD0wPgA+wD+QQGBBMEIAQtBDsESARVBGMEcQR+BIwEmgSoBLYExATTBOEE8AT+BQ0FHAUrBToFSQVYBWcFdwWGBZYFpgW1BcUF1QXlBfYGBgYWBicGNwZIBlkGagZ7BowGnQavBsAG0QbjBvUHBwcZBysHPQdPB2EHdAeGB5kHrAe/B9IH5Qf4CAsIHwgyCEYIWghuCIIIlgiqCL4I0gjnCPsJEAklCToJTwlkCXkJjwmkCboJzwnlCfsKEQonCj0KVApqCoEKmAquCsUK3ArzCwsLIgs5C1ELaQuAC5gLsAvIC+EL+QwSDCoMQwxcDHUMjgynDMAM2QzzDQ0NJg1ADVoNdA2ODakNww3eDfgOEw4uDkkOZA5/DpsOtg7SDu4PCQ8lD0EPXg96D5YPsw/PD+wQCRAmEEMQYRB+EJsQuRDXEPURExExEU8RbRGMEaoRyRHoEgcS",
    "JhJFEmQShBKjEsMS4xMDEyMTQxNjE4MTpBPFE+UUBhQnFEkUahSLFK0UzhTwFRIVNBVWFXgVmxW9FeAWAxYmFkkWbBaPFrIW1hb6Fx0XQRdlF4kXrhfSF/cYGxhAGGUYihivGNUY+hkgGUUZaxmRGbcZ3RoEGioaURp3Gp4axRrsGxQbOxtjG4obshvaHAIcKhxSHHscoxzMHPUdHh1HHXAdmR3DHeweFh5AHmoelB6+HukfEx8+H2kflB+/H+ogFSBBIGwgmCDEIPAhHCFIIXUhoSHOIfsiJyJVIoIiryLdIwojOCNmI5QjwiPwJB8kTSR8JKsk2iUJJTglaCWXJccl9yYnJlcmhya3JugnGCdJJ3onqyfcKA0oPyhxKKIo1CkGKTgpaymdKdAqAio1KmgqmyrPKwIrNitpK50r0SwFLDksbiyiLNctDC1BLXYtqy3hLhYuTC6CLrcu7i8kL1ovkS/HL/4wNTBsMKQw2zESMUoxgjG6",
    "MfIyKjJjMpsy1DMNM0YzfzO4M/E0KzRlNJ402DUTNU01hzXCNf02NzZyNq426TckN2A3nDfXOBQ4UDiMOMg5BTlCOX85vDn5OjY6dDqyOu87LTtrO6o76DwnPGU8pDzjPSI9YT2hPeA+ID5gPqA+4D8hP2E/oj/iQCNAZECmQOdBKUFqQaxB7kIwQnJCtUL3QzpDfUPARANER0SKRM5FEkVVRZpF3kYiRmdGq0bwRzVHe0fASAVIS0iRSNdJHUljSalJ8Eo3Sn1KxEsMS1NLmkviTCpMcky6TQJNSk2TTdxOJU5uTrdPAE9JT5NP3VAnUHFQu1EGUVBRm1HmUjFSfFLHUxNTX1OqU/ZUQlSPVNtVKFV1VcJWD1ZcVqlW91dEV5JX4FgvWH1Yy1kaWWlZuFoHWlZaplr1W0VblVvlXDVchlzWXSddeF3JXhpebF69Xw9fYV+zYAVgV2CqYPxhT2GiYfViSWKcYvBjQ2OXY+tkQGSUZOll",
    "PWWSZedmPWaSZuhnPWeTZ+loP2iWaOxpQ2maafFqSGqfavdrT2una/9sV2yvbQhtYG25bhJua27Ebx5veG/RcCtwhnDgcTpxlXHwcktypnMBc11zuHQUdHB0zHUodYV14XY+dpt2+HdWd7N4EXhueMx5KnmJeed6RnqlewR7Y3vCfCF8gXzhfUF9oX4BfmJ+wn8jf4R/5YBHgKiBCoFrgc2CMIKSgvSDV4O6hB2EgITjhUeFq4YOhnKG14c7h5+IBIhpiM6JM4mZif6KZIrKizCLlov8jGOMyo0xjZiN/45mjs6PNo+ekAaQbpDWkT+RqJIRknqS45NNk7aUIJSKlPSVX5XJljSWn5cKl3WX4JhMmLiZJJmQmfyaaJrVm0Kbr5wcnImc951kndKeQJ6unx2fi5/6oGmg2KFHobaiJqKWowajdqPmpFakx6U4pammGqaLpv2nbqfgqFKoxKk3qamqHKqPqwKrdavprFys0K1ErbiuLa6h",
    "rxavi7AAsHWw6rFgsdayS7LCszizrrQltJy1E7WKtgG2ebbwt2i34LhZuNG5SrnCuju6tbsuu6e8IbybvRW9j74KvoS+/796v/XAcMDswWfB48JfwtvDWMPUxFHEzsVLxcjGRsbDx0HHv8g9yLzJOsm5yjjKt8s2y7bMNcy1zTXNtc42zrbPN8+40DnQutE80b7SP9LB00TTxtRJ1MvVTtXR1lXW2Ndc1+DYZNjo2WzZ8dp22vvbgNwF3IrdEN2W3hzeot8p36/gNuC94UThzOJT4tvjY+Pr5HPk/OWE5g3mlucf56noMui86Ubp0Opb6uXrcOv77IbtEe2c7ijutO9A78zwWPDl8XLx//KM8xnzp/Q09ML1UPXe9m32+/eK+Bn4qPk4+cf6V/rn+3f8B/yY/Sn9uv5L/tz/bf///8AAEQgAZABcAwERAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQ",
    "AAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ",
    "2uLj5OXm5+jp6vLz9PX29/j5+v/bAEMAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf/bAEMBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAf/dAAQADP/aAAwDAQACEQMRAD8A/v4oAKACgAoAKAEJABJOABkk9gOpoA/BL/gof/wcL/scfsHfGnS/2WdA8K/Fr9rj9q++1bR9L1L4B/s1eH7bxV4i8Jy6skV5Fp/ifVri4WxXxhc6UzX2neAPDtr4i8WfPYPr9j4b07VLTUmAJ/8AgpB8eP8Agu7o/wAVvAPhn/gmB+xr+zv8Q/g34h+FmkeJ/E3xN+P3jHQ7DxZ4c+Il7qWof2r4I1LwhqPxi+HEehPoujHRJT5Fj4ti1G9uNQEetQPYNYKA",
    "fjd8OP8AgpL/AMHMPizxnqHhL4cfD/8A4JA/tLeN9Bj1G6174RfCb9or4F+JviFp0WjzeRq0N54c8LftdWfiC0bT5v8AR70m3k+xTfJdMjAhQD3Ff+DkL9t/9jvUbC1/4K0/8Ef/AI7/AAC8E3F9aWmo/HP4IT3/AIs8BWDzTLbOsVj4mW98F3uHljlWCx+OD37xo6WljeSlEYA/ph/Y+/bS/Zp/by+DWjfHn9ln4qaB8VPh1qs8mm3N7pYurDWvDHiK2t7e51Dwl428L6rFaeIPB3ivTobq2uLnQ9e0+0uZbC7sdXsGvdH1CxvrgA+pqAP/0P7+KACgBGZVGWYKPViAP1I/n+fFADRLGfuurf7pDfyJ/l+XNAAZEH3nVf8Aewv8yv8An04DAHj/AO0H8XdM+A/wG+NPxx1SOG80n4N/Cf4jfFXU7Z5vLW4sfh54O1jxbcW5dXRh9pGkrbfKysfOwvJywB/m5/8ABC//AIKefDj/AIJ7",
    "eLvi98ef+CivwK+KXgyD/gpTrPi3x58NP+Cleg/Dd/FusWmpp4m8Y6J8VND06/1PSNelvfC8PxDl1HxHrQ8Awax4hsfGGlaVH478D+K/Dkvh+90EA/sL/wCCaXxU/ZyTxF4n+IXhb/guf4l/4KCeHPG2jSWGhfCz4x/E39mezufBt9JqNjqMOujwvovg7wD8TdI8SwWsEukw2N1b+H9A+y6lf/a/DE15Fp9xpoBJ+xj4o/Zhtf2pPHPiDS/+CKupfsEeKrPTPFlxcftheLfhD+xZ4D0HXop5hFqemP8AEf4W/EXVfEP2vx/5zXDJ4afX9M151kuPEOoQwKblgD5k8bftm/AX9gv4kfEr4jftz/8ABfDwt+1X8GvEeheOtNP7Dz/A/wDZX8Y67fR65FPBo+jzWHwH0LWvGNxDpEUw06K1v9L8JeGtbDgeLrgWBuCoB+GH/Buz+114PsP+C5n7RnhX9n34HeMP2Yv2Of8AgoR8N/iF8Q/g",
    "L8C/Elte6TpUUfwsu5fE/gzxzoFksn9gDTbu20L40WdnpvhS61fwl4ROvan4C8PazqGneFonUA/0SQQQCOQRkH1B/L+X5UAf/9H+/cnAJPQegJP4Ack+gHJ6DrQB/N//AMFCv+Dij4Vfs1fHnUP2KP2Mv2f/AIm/8FCv227K9vNA1v4WfBm31J/B3w/8T2jJDqHh7xd4q0HQ/Feuaz4n8OyTwzeJvD/gzw5qFh4beK90fxd4v8Ka1Y3tlbgHx7Y33/B3p+2ARrGm2H7GX/BN7wfri7rPT9btfDXifxrYaY/ET38V3Y/tIa9Dqu1Q8qXlp4XugzENYWZHlqAfOn7V37IP/BZP9kz4TyfH79uv/g5AuPgB8Nk8Q6R4Xv8AxN4G+D/xZ8RaVB4g19LyXS9NtNJ+F/hfwxqszXYsLswyReHoLRFgYSyQFkRgDxD9jD4ef8FDP26tb8ZaT+wF/wAHQ3iP9oTxN8OtHsfEHivRvGHwE/aI8Fx6",
    "Pp+o6gNM0+4u4vitoeoWl3b3N6fJ22VrqUqj95JaiEO6gH0v+0t+yR/wdoWP7P8A8Z/gRrPx3/ZK/bx+Fnxd+Ffjn4Y+KNNsbLwL4K+JjeF/HHh+70LW5NB1PxH8P/gYlv4kj026m/smW78Ta7BFqBjkNlfSIgYA8t/4Jcf8FMfgB+yP8Afgh/wRJ/4LRfsV+J/2bJvDUfiXw14X8b/tMfDvSPFX7PHxRXxd8RPEninTNT8Y2HinQ3sfDFnFqXjMaBY/ELRX8b+ALeW1fWta8ZeD7V5fs4B+xvxm/wCDWT/gjL8aNQuNbsf2dvEfwe1G+zJcT/BL4seN/CummSQmQyWnhXXb7xd4P01PnBjh0vRbW0Eezy4jHs3AHzTB/wAGbv8AwSbjuVkm8Yftk3tmjBl0u5+MvgMWWAQfLLW3wet7wRnkZS6SQD+MEB6APuv9nH/g29/4I7fsyatp/iTw/wDskeG/iX4q0y6t72y134+eI/E/xoC3",
    "Fo3mRSr4O8W6hN8PjOkqLNG6eDWdJkVo9pGKAPy88S634b/aQ/4O5f2d9E+CUdlqfhn/AIJ+fsSeJ/CfxnvfCMNtNoHg7VP+EW+K9jH4Pd9KQaTYroGrfHbwD4VudKtTGmka7NqWhvawX+lXtpAAf2LopVEU9VVVP1AA9vT0/KgD/9L+vD/gq1+094n/AGNP+CdX7X/7S3gny08b/C34KeJtR8C3UsUdxFpvj3xA9n4O8D6xPaypJFdW2ieJ/EWma1cW0q+XcJp/kvhHc0Afwuf8Ebv25fin/wAEKPC0Pxe/bw/Yv8deL/2bP+Ciei+Afj74T/b1+F1laeP/AB6kHi3TPPtvB3j/AMU3t8LDWbOTUbi78War8OdZ8V+FfiB4d8Sajr/iW10fx3aeKNNe0AP22bxj/wAEaP8AgpD8ZNV+Pfgf/gvb+3B8G/EXjTUU8QL8FtH/AOCgnib9lfwz4TuGt7df+Ef8CfDT4s+FfD974Q061liJ",
    "XS/CmpXVit1NNJZTMZhKwB+8/wAYv2m9R+EX7NOg3v7Ivw+X/gop408OWfhPwXa+AdF/ah+CGj+MfFvhyx0OWw1Lx14r+J3xI8SPpHifU2j0+2l18w22qeJfE2ras97b6ZMpvZogDzL9i79uL47fEgeMYv2uP2DIv+CcnhfQdPh1HwxrXjv9qj9m34gaN4y1KW9ittR0uDRvBOo+H/EWgXVnZMmovq2teH00W8t45bW21R71Ft3APx8+Nngz/gkN+zb8W5Pjv8Wf+Dgr9ujTdbsvFD+Mp/hd4f8A+Cn+q/Ey2Mtvq/8Aar+GB8PvhloHi7x5c+EztGkf8IsG8h9GYaWZRbNQB+bv/BVn/gpRL/wcIeBpf2Bf+CXf7F3jX496B4c8V6X8Q/HP7YXxd8JQeBfCfwdsvBSXGuXeoeA9V1hpV+G6+KtIgm0LVvEfjzWvDniDxBoFxqfgjQPhvrmp+ILLUbIA5L/gkZ+25/wc2/Fv9jLwJ8Qf",
    "2TPA37Mv7YvwF+F+o3fwK0Ow+Nt34P0L4raQvwy0Tw7FbaNqmsyfET4R6v4hWz0LWNDt7HXdU1fxFrOoW8QfUrl7lXmlAP0+/wCG8v8Ag7M1XdpFj/wSE/ZL0e/k/crrOo/ELR30uGQ/L9o2y/tcRxGNT82HkcY6Bs/KAcb4k/ZT/wCDr79uLR9Z8K/Gr9rf9mP/AIJ+eANV07UItQ8PfAa52eO7yW6tJobTT7bxP8M7Hxn4x0u0nuHhttQ1LT/jPpMtjZSXF7HbalJAllcAEP8AwaO2fwa+GXgv9t79mvxp8KW+HH/BRj4H/HXUfD/7WGteKNYutd8ZfELw1D4g8Q2Pgm9sbvUpWNlong3xTa+LfDmtaXoQvNOv9Xn0Xx7qOr3t143sI7QA/snoA//T/so/4KJfCf4L/HL9h79qf4T/ALQ3jvR/hb8GvHPwR8eaL48+Juv31lp2j/DfSjpEl7bfEO9utSurPT0TwPrFnpniaOO8uI4b",
    "qbTUsiWe6RGAP4o/+CHn/Bw3+zd+zb+zX4e/4J9f8FGo9Rvvgp4M1bxl8OPgN+1PbfDfxB41+DXjv4WWfiAungr4h+Eb/wAOHxabTw1JrEcmg6xb+FNcS28F67oWheOPDvhPUNA/tHXAD912/wCCaP8AwbXf8FI4ZPFPwx8A/sZ+NdX8Rs16b39l/wCMMPwp8QWtxO7NIb/wP8KvG/hUadqDyMWmtNZ8FxXKSArNbgl0oA8q1/8A4M9P+CQur3L3GmSftWeDldiyWvhn406XeW0QPIWOXxV8OPEl0yLxjfdyuRjLnrQBS0j/AIM6/wDgkdYXCT6jrH7XfiYKRm21z4yeG4LeUD+F5NB+FWi3aqRwdl1G3JKsOKAPX4P+CKn/AAbn/sGWzeJ/jD8Mv2bvDk+jj7dJrv7Wv7Qd74jtX+yL5jLJ4U+JnxAg8L3rvtyLSLwpcNM42RwMW8pgD82f+Cov/Bx/+xd8Lf2XPi5+x1/wSJ8Nw/EL",
    "x7rHw68WeHbn4hfBP4VyeAv2ev2dvBWr2MejeNfG+iwWvhzQ/wDhItd07SdTk0/wzquh+G7bwBousahZ+I9a8YXX9kW/h7WgD9rf+Dcj4Q/AT4O/8Ej/ANmDR/gN8U/D/wAZdI8W6VrnxI+IvjnQhJb20vxi8a6kNQ8f+FLzSr2ODU9G1D4bXEen/Dp7DWbSw1d7bwxb6ne2UP8AacIoA/coLbE8LASfQR5P+f8APagCYqpUqQNpBUjoMEYI49s9KAP5LP2jPgf8WP2OP+Dm/wDZC/av+C3wz8ea/wDBz/goj8KPEfwM/aUufBPhXV77w/p/jHwvoa6VeeJPFl7o1tLpOiWlpaeHPgx4/ur7WZLOW5g8L+MNUjkneHUJEAP60kJKKW+8VBOOmcc49s9PbFAH/9T74/4OLtR8aftmftxf8EsP+CNWleMNd8D/AAn/AGpPiFd/GL9oq68PXf2XUvEfgPwTrN3Fo2mQvtMFwND0Twf8T/Em",
    "m6fqkN9o7eM18Ha7c2M1z4asnUA8f+P/APwWw/4JA/szeLvHX/BLzxh/wTO8S/Eb9gz9j7xYfgB4t8d6d8NPAnxF+F3gH4jWk+p6Vqap4E8YQf2lc3dx4ks/Ekl38TNS8eWHxJ+IHiLTfFPiiwsfEN4zX12AdL8I/wDgjL/wbKf8FVLObxr+xV46vvCuu3Fmmq6l4T/Z/wDjt4l8J+P/AAvKYI5JLnWfgf8AG+w8X+I/CUEFxIUD2vhW00R5IpFsLp4VV1APRv8AiEn+G3hxng+En/BT3/goZ8PNOjYiCwj8deHr1bZMnZED4di8Ex4RcAZtkOOoJJNAA3/Bpv4b1weR8SP+CrX/AAUP8Z6Y/wAs9k3jXSrRZUbho92vaj4rtxvHHz2kg9UbOGAPTvCn/BqZ/wAEZ/gNpevfE/43J8evjdpngTQNT8beNtX+Nvxr1S00i10Lw7YX2s6xrWrWHwh0D4fanNp1rp2l39zNFJdXQuI7WaOI",
    "TvlFAPhL4Y/8HDf/AARa/Zg1eP4G/sf/APBOPxVZ/sYeMPEOm/Bv43ftC+HPgx4P8FeANTh8ape2At/E/hXxDp+reM/i/puo6BJqd1qvh34neIPD/i3VvDdnrjWPhnUhbNDOAfJt98E/+Chn/BNL/gtT8bf+CZn/AARm+Onw8+DHw9/bI8E6B+1J8NPBnxytbTxh8N/Bei6Z4U8V6trel+H7nxR4U+JM+navok3hnxp4Z0TUrfQrrVPEXgfTfB+meL9S1C68Nadq8AB+qsn7PP8AweB6DGdTtP29/wBgPxdLjzDoV34P8JWsMw4YwLcP+yppSru+6GW/gz085ASaAMG9/wCCgH/Bz7+xJCfEP7Vn/BNL4L/tm/CjSSb/AMQeKv2VdWli8e/2VZDdf3MNh8PfEfjfU4kjtxLdtNdfA77LGkJad7eFXdQDb/aj/wCDnHQvFv8AwTA8Q/tsf8E//C2jn4zfB39oH4LfDX9pX4C/tGeH9Sk8",
    "S/CPwt4+k8V+Zez2PhTXbCx1vTfGGveFY/CfhfxnaaqlrBDdayl/o+k+LNObSLQA/rD+HvjTS/iN4E8GeP8ARCTo3jfwp4a8X6SxkEu7TPFGh6fr1gfNAUSf6JqMP7wKu/G7AyBQB//V/QH/AIKPf8rVf/BFf/s374if+m/9qH/CgD8Rx+2F8Wv2H7H/AIOivjV8GLTwJf8AjG8/4KP/AAB+HMtn8S/Bej/EXwdN4c8b/HT9r1PEkWo+CfEcdz4b12S+07SW0lE1vT9Qtbaz1K/mgt1vjbXNuAf0NfGH/g2p/wCCff7Zngb4ZftJfBDTPE//AAT4/aT8UeCfBHxHs/Hv7JuoXnh7wLpHjHxN4Y0zxFPe2/wmv9STStFsNPvtXuFsYfhzrvw61TyIoBNq80iu8oB8ufCD9qr/AIK2f8EY/wBuz9jj9jD/AIKPfHnwp+3L+yB+2l44n+DvwT/aCa1vF+MHgnxc2r+GPDOmP4m1LVLK38X3",
    "c1hrnjDwdL4r0LxrqnxCgu/DniBtW8JeP5dQ0DUtIcA9n/4KI/t2/wDBTn9r3/gpr4x/4I/f8EqPGPw//Z21D4M/CXSPiP8AtQftQeNbVLvWtBsPEmn+EdWl03wXPcaD4nuNIsdMsPHvg3RrSbwz4Xu/G3iHxhrNybXWfCPh3w9d6xKAffH/AASq/wCCJWnf8E8/iT8Tf2lfi7+1x8fv2y/2rPjh8P0+HvxS+IfxT17UovBN5oM+taX4murbT/Ber6z4s1nV9Qi1XS7e0tPEHjbxZr1zY6X9ttdB0zw3b63rdrfgH5m/8Hcnw/8AAnws/wCCW/7Ongr4Z+C/Cfw88HWP7e3wquLLwn4F8N6L4Q8M2c9x8MPjdNPNa6B4dsdN0mCaaaaWWWZLMTPJLK7yEu+4A+Qv+Cp37cHwi/4J2/8ABzH+yJ+1X8ctH8f658NfAX/BP7TtL16w+Geh6X4j8XGTxxp37Rng7S7ix0nWNd8N2Nzb2up6",
    "vbT6k0msW8kNik00KXEqJbygH6B3X/B4/wD8EpUtSNF8CftneI9SCAQ6Vp3wb8BR3U0vAWIyXfxhigRmPGQ0gzxzjNAHmupf8HI/7bv7Vccnhn/gl9/wRp/ac+J/iLVD5Wj/ABS+PWnapoHw40KR/wB3Bd6/beEbO08Jm1MskTP/AGv8cPDFqF3eZO6btwB+f37Vf/BIT9p/4Ef8Ek/+Cxv7dP7f/jfwb4h/bb/bAi+B/wAQfGngX4Y2elW/gf4Y6P4L/aQ+Hfja9t5r3w9bWHhzWvGGsTPHa6nJ4ftb3RtD0rRmSHxP4t1TxFrWrqAf16f8Ep/iLN8QP+CZH/BPvxhLIXudZ/Y6/Z7F5ITlpL7Svhn4e0S9kkO1iZWutMmMhJyXz1wTQB//1v0C/wCCjvP/AAdV/wDBFfn/AJt++IvX20/9qH378gfpuyAoB+I//BUb9if9pn9lj9lX/gv98VPjp8NLnwR8P/2pf+Cmf7L3jf4CeJZN",
    "b0LVbT4i+EbP4lftL+LrjxBpcGlX93e2WnxaP8TPCSudXt7C4XU7q/0owfbNH1BIgD/Q1/Zb/wCTbPgB/wBkS+Ef/qufDFAH4d/8Fy/2H/2nP2s/2sP+CLXxD+Afw0n8d+Dv2af2zm8d/HHXItd0DSIPh74Ll8V/BHxT/wAJRqkOsahaXd5pMWlfDnxT5r6Tb310t/Bp2mJayXms2COAfKH7CQ/46z/+Cu2R/wA2h/D0j8dJ/ZDIP5H2/qwB/XZQB/JH/wAHkP8Ayjd/Z+/7Pw+En/qrPjVQB94ePv8Agl78Y/Hn/Bc/9mb/AIKaw+I/hlcfs+/Cr9jrXPgx4s8H6vJrD/EK+8b3uj/FDQ9Mg0zRjo114dvdBurf4nWWrvqt3rdrNaf2Hqmnvpk009hcOAft7YeAPBOlzrd6d4R8L2N0pDC5svDmh2k4cfxCa206KVTnuGz+WKAOrdFwc7jlkyCzFfvrxtJ2gew4PfHC0Af5/wD+yb8e",
    "/jn+07/wbqf8F4dY/aA+L3xD+M2teFvjn8dLLw5rHxJ8Uan4t1PQtHj0L4TeMm0PR77V5bifTdBj16e81Gy0Gxa30bTLi6uP7LsLGOV0YA/ps/4IOXbal/wR1/4J53ExLNH+zxodiCcHEema74g02JecnCxWqKB0AGBjpQB//9f+mz9pH42/8E5PC3/BXP8AYQ+EHxp+DeoeI/8AgoB44+FfxT1H9mD4yp4OfUtF+HXg9rLxmuu6HrPiIeJbIWuoeKbbQ/H8HhaUeFPEp8OyvrW/U/CyeKxNqgB/O74Y+Ef7U/8AwXS8Q/8ABwL+wF8R/wBqvWtI0H4Mft8/BvUv2ebjxzob+LvB/wAKPDXgv4o/tAeHdS8F6B4f0ifR9Q07QtW8H+EPDsMdvZXjxLrmgwavdwtf654i1O9AP7dfhl4Ji+G3w68B/D2DUZdXh8DeDPCng6HVZ7dLSbUovC3h7TNAjv5bWKWaK3lvU04XUkEcjpC8xiR3",
    "VA7AH87X/BeX9rv9pP8AZp/a8/4IgeCvgT8YPFnwz8J/Hn9tp/Cfxl8P+HJbSPTfiV4Ui8X/AAI8Mjwx4tgubW4/tXw++j+P/FUEmkyFbRrrUYdV8tdX0jRb/TwD5x/YSOf+Ds//AIK7f9mh/D0flpX7IYH6CgD+uygD+SP/AIPIf+Ubv7P3/Z+Hwk/9VZ8aqAOy+KPx3+NVj/wdTfsTfA2x+LPxDsvgvr3/AAT28UalrnwmtPFmr23w51jVJ/DPx/16XVdV8Hw3CaHqGrtq/hPwzf8A9rXVnLqaS+H9HjjultrGC3QA/qoQ5RCepVSfxH4fy/KgAbp9Cp/Jgfbj1PYc84xQB/nk/D3wN44/4Jtf8G+P/BYn4eftueGdT/Zu+In7T37Uvxc8Jfs/eBPiOkGm+LvjBea1oHwu8ORXngHQIZ59R8RaAx0fXdS/4Sewhl0A+HtJvfE0d9LoKQX84B/WR/wRJ8C+Kfh5/wAEkv8Agn34V8Ua",
    "Bq2g67a/s1+CdWvtH1Wyms9SsV8VG+8V2KXtnMFntJ5tN1uzujbXKR3MKTolxFFMHjUA/9D9AP8AgpEyw/8AB1N/wRVmmYQwv8BPiHAkshEcbzvZ/tNxLCsjYRpnlngjWIMZGkniTbulRaAG/wDBvLqFjp//AAVZ/wCDizwzfXdrZ+I7n9sLS9at/D91PHBrVxo9n8Xv2mbe81W30uQpfT6bZz6xpMV3fRQPbWsuqaalxJEb61E4B/XyCrDKkMPUHI/Qn+f5UAfyJ/8AByx/yfJ/wby/9n83H/qzv2VqAF/YS/5Wz/8Agrt/2aH8Pv8A01fsh0Af11kgAkkADqTwB7np/P8AKgD+Rf8A4PIdT00f8E9f2afDx1CzGva7+3X8MbjRNENzF/a+r22m/C/4uQ6lcaZpu/7Zf29hLqmlxXtxaxSwWk2pafBPIkt9apKAfCv/AAVb/bGh/YN/4OXv2VP2krn4NfE349R/Df8A4J/6bp2sfDL4",
    "Q2Kan4+ni8Xaf+0P4XnvrbT5IJ1WLw/FrCa1qaXS26pp0LyvNChV6APt3/iLY+HurqNP8C/8Evv+Ch3irxGyiO30Q+B/D1t5txjasBm0dvEd8Mt8u5NHd+eIGI20AZeo/wDBV3/g4c/bZVvD/wCw3/wR+m/ZR0LW4/Kh+M37YeqalDJodkfmPiHTdL+I9j8GdBeeDazxwQeEPiMG+5Hpl62EoA9a/ZF/4N0/G3j/AOPGgftr/wDBaX9qDVf+Cgn7Rmiz22peFfhLcPfSfs2fD67t54dRsrM6RqljosfjHRdM1OOPULLwRong/wCHXwua8F0dd8KeMorjzaAP6rlUIoUdAMdu3HbAGAMAAAAcKFUAUAf/0f15/wCDkH9jz9ofxFpf7H//AAUx/Yx8G3/jn9pT/gm98Wo/iPfeCNBsL/VNc8cfB6+1fQfEXiGG30bTI7nVfEsXhXXvDFrLq3h7S7Zr648DeLfHl5bCaWxS1uAD8hPEOo/8",
    "Eif+C2f7QGnftY/sfft3fFP/AIJBf8FWNY07TLPxD4f8T6l/wru38dePdP0+x00Kb6y8Q+FdL8V+Iro6TaeG31T4dfEnSPEHiXR9OtdV8YfCi9117i3YA+y/+G2/+Djf/gkputP24/2V/Dn/AAU+/Zm8PlUuf2if2cTPD8U9I0C0Lxf2t4j/AOEU8Lxamltp9lJFdahP8RPgtYw3FzEyXfxKYNLqCgH5/f8ABQz/AIK5fsn/APBXf9sL/ggvdfsryfEeLx/8Mv28tDk+KHwg8f8Age90Px34IbxR8SP2c30mSe50mfXfCPiGwupPC3iMJeeGfEepvaRaTNNrFppXmxJKAe0eIf8AgoP+zX/wS7/4OX/+Csfx8/a513xV4T8IeJf2YPhf4W8C6X4c8Ga14p8U+P8AxNqnhX9mDXNO0Xwvp9qlvpwa80rw1rl1HrOvatovhqH+zpbe71m2naNGAPpp/wDgrn/wXF/4KrFtH/4JK/sDv+y1",
    "8CtZkMFn+2N+1vHZCabTZFdY9f8ACVt4gsU+H6vEtxGLuy8GeGvj/dwtEGjuoX3KgB8feNP2dv8AgnX/AME3Pj74T/a//wCC6f8AwVK8bf8ABR39uj4Y6ja+LPCf7MHg28vfiJpvg/xdpt1b6rodnL4DvNUvNQttP0HVtPs9Y8Mab47v/gR8Nbi+s7ZNT8HapawJb0Affv8AwQ6+FXx8/b2/4KKftdf8F2v2jPhb4l+D/gb4s+Frf4H/ALFHgDxlBc2Wuw/CmGPQtPvfGNrbyw6fK1jY+E/Cuj6HB4ptIZdF8W+L/GXxIvNEcafplvcXQB/Xf5a+sn/f2UfyZv8APrztADy0yCVBK/dLfMw+hbcR17H8/wCEAfQAUAf/0v79yARg/ocEe4I5B9xzQB+Sn7e3/BEH/gnD/wAFGE1XWPj58AdD0r4o6mkmPjt8J/s/w1+MkN3J5gW+1PxNotlJpnjmW3EhFtbfEfw/4wsof4IEYB1APwzP",
    "/BO3/gv9/wAEgJBqX/BNr9q/T/8Agod+y54f/fW/7Jf7TG1PHOi6BahJToXg9Nd8Q2loIrGzSeOKT4V/E/4ezX95KGh+G15K6WzAE/7Lv/Bdj/glAP2mrrxZ/wAFEv2BdH/4Ji/8FEvClhe2XiX4lfE/9nSLWNVlvr2Ga01GfTPibovw7034u+G9S1yAahD9t8XeDLWOXRbo6NB481q2ldbgA7X9uz/gvF/wQr1T4hfDjx58M/2b/B//AAVM/bGsbVdB+DFh4D/ZxtdY8VaNdyXEtzo+hzfFD4n/AA/fWrG2F691c6NpXgrwx8Qta0bUbqe+stC0+W6kuXAOAX4L/wDByb/wWIaMfG74jaB/wRx/Y+8QBVPwz+HkOrx/tDa94WuCkf2XVbLTdXtPiULqW1M9jqmn+L/G3wa0R0lzJ8P7m2xbMAfrH+wZ/wAG6v8AwTO/YQudL8ZaT8Iv+Gg/jfZypqNx8cP2k2074l+KIddbdNNq3hfw",
    "tdafb/D3wbex3ss1xY6rpPhqXxRArqlz4nv5lNwwB+64UL0GP1/AZ6AZ4A4HQdKAFoAKACgAoA//0/7+KACgBCAwwwDA9QRkH8CD39vyoA+af2jv2SP2W/2ptF0/Sv2lf2ePgz8etP0Z5P7Eg+LPw68L+OJdDNwwkuG0O+13TbvUdFNw0afaBpd5ZrPtHnK2BQByP7N/7CX7Fn7LOpalr37Nv7KfwA+BniDUIpLPUPEfwx+FvhHwp4lvbGf/AFthceJNP0tNebT3Mau1gupJZs6hmt2KgMAfYgVVzgAZOTgdT6ngZJ9Tk+9AC0AFABQAUAFABQB//9k=",
]
